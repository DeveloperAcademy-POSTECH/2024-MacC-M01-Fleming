//
//  test2.swift
//  Fleming_App
//
//  Created by 임유리 on 10/15/24.
//

//원래 함수
//makeCameraView(touchPoint: $touchPoint, imgPosition: $imgPosition).edgesIgnoringSafeArea(.all)
//현재 함수
//test2View

import SwiftUI
import Vision
import AVFoundation

struct makeCameraView: UIViewControllerRepresentable {
    
    @Binding var touchPoint: CGPoint? // 엄지와 검지가 맞닿은 지점
    @Binding var imgPosition: CGPoint // 이미지의 현재 위치
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = CameraViewController()
        viewController.touchPoint = $touchPoint
        viewController.imgPosition = $imgPosition
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

class CameraViewController: UIViewController {
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var touchPoint: Binding<CGPoint?>?
    var imgPosition: Binding<CGPoint>?
    
    
    // 좌표 변화 부드럽게 하기 위해 추가
    private var previousThumbTipLocation: CGPoint?
    private var previousIndexTipLocation: CGPoint?
    
    private let handPoseRequest = VNDetectHumanHandPoseRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }
    
    func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .high
        
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("전면 카메라를 찾을 수 없음.")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)
            if captureSession?.canAddInput(input) == true {
                captureSession?.addInput(input)
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            previewLayer?.frame = view.bounds
            
            previewLayer?.videoGravity = .resizeAspectFill
            // TODO: 기기 환경에 맞춰서 카메라 돌리기
            previewLayer?.connection?.videoOrientation = .landscapeRight
            view.layer.addSublayer(previewLayer!)
            
            captureSession?.startRunning()
            
            let output = AVCaptureVideoDataOutput()
            output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            captureSession?.addOutput(output)
        } catch {
            print("전면 카메라 설정 중 오류 발생: \(error)")
        }
    }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        do {
            try requestHandler.perform([handPoseRequest])
            guard let observation = handPoseRequest.results?.first else { return }
            
            // 엄지와 검지의 위치를 추출
            let thumbPoints = try observation.recognizedPoints(.thumb)
            let indexFingerPoints = try observation.recognizedPoints(.indexFinger)
            
            if let thumbTip = thumbPoints[.thumbTip], let indexTip = indexFingerPoints[.indexTip],
               thumbTip.confidence > 0.8 && indexTip.confidence > 0.8 {
                
                // 엄지와 검지 좌표 확인
                print("Thumb: \(thumbTip.location)")
                
                // Vision 좌표는 (0,0)이 좌측 하단
                //(1,1)이 우측 상단
                // TODO: 이유를 찾아봅시다
                
                //여기 세로쪽 좌표 보정시도함 -> 이후 가로도 보정시도함 완료
                let thumbTipLocation = CGPoint(x: (1 - thumbTip.location.x) * 0.95, y: thumbTip.location.y * 0.95)
                let indexTipLocation = CGPoint(x: (1 - indexTip.location.x) * 0.95, y: indexTip.location.y * 0.95)
                
                // 엄지와 검지 좌표 부드럽게 하기 위해 추가 (이전 좌표와 현재 좌표의 평균 사용)
                let smoothedThumbTip = smoothCoordinates(current: thumbTipLocation, previous: previousThumbTipLocation)
                let smoothedIndexTip = smoothCoordinates(current: indexTipLocation, previous: previousIndexTipLocation)
                
                previousThumbTipLocation = smoothedThumbTip
                previousIndexTipLocation = smoothedIndexTip
                
                
                // 엄지와 검지의 거리를 계산하여 맞닿았는지 확인
                let distance = hypot(thumbTipLocation.x - indexTipLocation.x, thumbTipLocation.y - indexTipLocation.y)
                
                // 맞닿았다면 화면 좌표로 변환하여 전달
                // 일정 거리 이하일 경우에,
                if distance < 0.05 {
                    DispatchQueue.main.async {
                        if let previewLayer = self.previewLayer {
                            // 카메라 좌표를 화면 좌표로 변환
                            let convertedThumbPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: thumbTipLocation)
                            let convertedIndexPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: indexTipLocation)
                            
//                            print("Converted : \(convertedThumbPoint)")
                            
                            
                            print("Converted Thumb Point:", convertedThumbPoint)
                            print("Converted Index Point:", convertedIndexPoint)
                        
                            // 검지의 좌표를 사용하여 원을 그리도록 업데이트
                            self.touchPoint?.wrappedValue = convertedIndexPoint
                            // 엄지와 검지가 img에 닿으면 img 위치를 업데이트
                            
                            
                            let center = CGPoint(x: self.imgPosition?.x.wrappedValue ?? 0, y: self.imgPosition?.y.wrappedValue ?? 0)
                            let size = CGSize(width: 100, height: 300)
                            
                            let imgFrame = self.rectFromCenter(center: center, size: size)
                            
 
                            // 여유 거리 추가를 위해
                            let margin: CGFloat = 20.0 // 여유 거리 일단 20
                            let extendedImgFrame = imgFrame.insetBy(dx: -margin, dy: -margin)
                            //  원래의 imgFrame보다 margin만큼 더 큰 사각형 영역
                            
                            //인정 범위 확인 위해
                            let testView = UIView(frame: imgFrame)
                            testView.backgroundColor = .blue
                            self.view.addSubview(testView)
                            
                            if extendedImgFrame.contains(convertedIndexPoint) || extendedImgFrame.contains(convertedThumbPoint) {
                                let middlePoint = CGPoint(
                                    x: (convertedThumbPoint.x + convertedIndexPoint.x) / 2,
                                    y: (convertedThumbPoint.y + convertedIndexPoint.y) / 2
                                )
                            
//                            if imgFrame.contains(convertedIndexPoint) ||          imgFrame.contains(convertedThumbPoint) {
//                                let middlePoint = CGPoint(
//                                    x: (convertedThumbPoint.x + convertedIndexPoint.x) / 2,
//                                    y: (convertedThumbPoint.y + convertedIndexPoint.y) / 2
//                                )
                                //self.imgPosition?.wrappedValue = middlePoint
                                
                                // 애니메이션을 추가 -> 자연스럽게 이동
                                DispatchQueue.main.async {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        // 이미지의 새로운 위치 설정 여기로 변경
                                        self.imgPosition?.wrappedValue = middlePoint
                                    }
                                }
                            }
                        }
                    }
                } else { //손가락이 닿지 않았을 때의 경우
                    DispatchQueue.main.async {
                        self.touchPoint?.wrappedValue = nil
                    }
                }
            }
        } catch {
            print("에러 \(error)")
        }
    }
    
    //부드럽게 하기 위해 추가 -> 현재 좌표 이전좌표 평균값 사용
    func smoothCoordinates(current: CGPoint, previous: CGPoint?) -> CGPoint {
        guard let previous = previous else {
            return current
        }
        let smoothedX = (current.x + previous.x) / 2
        let smoothedY = (current.y + previous.y) / 2
        return CGPoint(x: smoothedX, y: smoothedY)
    }
    
    func rectFromCenter(center: CGPoint, size: CGSize) -> CGRect {
        let origin = CGPoint(x: center.x - size.width/2, y: center.y - size.height/2)
        
        return CGRect(origin: origin, size: size)
    }
    
}

//#Preview{
//    makeCameraView(touchPoint: <#T##Binding<CGPoint?>#>, imgPosition: <#T##Binding<CGPoint>#>)
//}
