//
//  makeCameraForCircle.swift
//  Fleming_App
//
//  Created by 임유리 on 10/17/24.
//


import SwiftUI
import AVFoundation
import Vision

struct makeCameraForCircle: View {
    @State private var touchPoint: CGPoint? = nil // 엄지와 검지가 맞닿은 지점
    @State private var success = false // 성공 여부 상태
    @State private var leftCheck = false // 왼쪽 원에 닿았는지 여부
    @State private var pathPoints: [CGPoint] = [] // 경로를 그릴 점들을 저장하는 배열
    @State private var circlePositions = [
        CGPoint(x: 100, y: UIScreen.main.bounds.height - 150), // 왼쪽 하단 원 위치
        CGPoint(x: UIScreen.main.bounds.width - 100, y: 100)  // 오른쪽 상단 원 위치
    ]

    var body: some View {
        ZStack {
            CameraView2(touchPoint: $touchPoint, success: $success, leftCheck: $leftCheck, pathPoints: $pathPoints, circlePositions: $circlePositions)

            // 왼쪽 하단 원
            Circle()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .position(circlePositions[0])

            // 오른쪽 상단 원
            Circle()
                .frame(width: 170, height: 170)
                .foregroundColor(.green)
                .position(circlePositions[1])

            if let touchPoint = touchPoint {
                Circle()
                    .fill(Color.red)
                    .frame(width: 30, height: 30)
                    .position(touchPoint)
            }
            
            // 경로 그리기 부분
            if leftCheck && !pathPoints.isEmpty {
                Path { path in
                    path.move(to: pathPoints.first!)
                    for point in pathPoints.dropFirst() {
                        path.addLine(to: point)
                    }
                }
                .stroke(Color.purple, lineWidth: 5)
            }
            
            
            // 성공 메시지
            if success {
                Text("Success!")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                    .bold()
//                self.leftCheck.wrappedValue == false
//                leftCheck = false
               //clearPathPoints()
//                pathPoints.removeAll()
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        .onChange(of: success) { newValue in
                    if newValue {
                        leftCheck = false
                        clearPathPoints()
                    }
                }
    }
    
    // 경로를 초기화 하기 위해
       private func clearPathPoints() {
           pathPoints.removeAll() // 배열 clear
       }
    
    
}

struct CameraView2: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> UIViewController {
//        <#code#>
//    }
    
    @Binding var touchPoint: CGPoint?
    @Binding var success: Bool
    @Binding var leftCheck: Bool // 왼쪽 체크 바인딩 추가
    @Binding var pathPoints: [CGPoint] // 경로 바인딩 추가
    @Binding var circlePositions: [CGPoint] // circlePositions 바인딩 추가

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = CameraViewController2()
        viewController.touchPoint = $touchPoint
        viewController.success = $success
        viewController.leftCheck = $leftCheck // 왼쪽 체크 바인딩 추가
        viewController.pathPoints = $pathPoints // 경로 바인딩 추가
        viewController.circlePositions = circlePositions // circlePositions 바인딩 추가
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

class CameraViewController2: UIViewController {
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var touchPoint: Binding<CGPoint?>?
    var success: Binding<Bool>?
    var leftCheck: Binding<Bool>? // 왼쪽 체크 바인딩 추가
    var pathPoints: Binding<[CGPoint]>? // 경로 바인딩 추가
    var circlePositions: [CGPoint]? // 원의 위치를 옵셔널 배열로 선언

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

extension CameraViewController2: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        do {
            try requestHandler.perform([handPoseRequest])
            guard let observation = handPoseRequest.results?.first else { return }

            let thumbPoints = try observation.recognizedPoints(.thumb)
            let indexFingerPoints = try observation.recognizedPoints(.indexFinger)

            if let thumbTip = thumbPoints[.thumbTip], let indexTip = indexFingerPoints[.indexTip],
               thumbTip.confidence > 0.8 && indexTip.confidence > 0.8 {

                let thumbTipLocation = CGPoint(x: 1 - thumbTip.location.x, y: thumbTip.location.y)
                let indexTipLocation = CGPoint(x: 1 - indexTip.location.x, y: indexTip.location.y)

                let smoothedThumbTip = smoothCoordinates(current: thumbTipLocation, previous: previousThumbTipLocation)
                let smoothedIndexTip = smoothCoordinates(current: indexTipLocation, previous: previousIndexTipLocation)
                
                previousThumbTipLocation = smoothedThumbTip
                previousIndexTipLocation = smoothedIndexTip
                
                let distance = hypot(thumbTipLocation.x - indexTipLocation.x, thumbTipLocation.y - indexTipLocation.y)

                if distance < 0.05 {
                    DispatchQueue.main.async {
                        if let previewLayer = self.previewLayer, let circlePositions = self.circlePositions {
                            let convertedThumbPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: thumbTipLocation)
                            let convertedIndexPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: indexTipLocation)

                            self.touchPoint?.wrappedValue = convertedIndexPoint

                            self.pathPoints?.wrappedValue.append(convertedIndexPoint) //경로 보여주기 위해

                            
                            // 원의 중심 좌표 가져오기
                            let leftCircleCenter = circlePositions[0]
                            let rightCircleCenter = circlePositions[1]

                            // 왼쪽 하단 원의 frame을 설정
                            let leftCircleFrame = CGRect(x: leftCircleCenter.x - 50,
                                                         y: leftCircleCenter.y - 50,
                                                         width: 100,
                                                         height: 100)

                            // 오른쪽 상단 원의 frame을 설정
                            let rightCircleFrame = CGRect(x: rightCircleCenter.x - 85,
                                                          y: rightCircleCenter.y - 85,
                                                          width: 170,
                                                          height: 170)

                            // 왼쪽 원에 닿았는지 체크
                            if leftCircleFrame.contains(convertedIndexPoint) {
                                self.leftCheck?.wrappedValue = true // 왼쪽 원에 닿았을 경우 true 설정
                                
                                self.pathPoints?.wrappedValue = [] //clear 위해

                                
                                print("레프트 체크 true")
                            }
                            
                            //이때 부터 시작
                            if self.leftCheck?.wrappedValue == true {
                                // 경로에 점 추가
                                self.pathPoints?.wrappedValue.append(convertedIndexPoint)
                            }
                            
                            // 오른쪽 원에 닿는지 체크 및 성공 여부 확인
                            if self.leftCheck?.wrappedValue == true && rightCircleFrame.contains(convertedIndexPoint) {
                                self.success?.wrappedValue = true
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.touchPoint?.wrappedValue = nil
                    }
                }
            }
        } catch {
            print("에러 \(error)")
        }
    }
    
    func smoothCoordinates(current: CGPoint, previous: CGPoint?) -> CGPoint {
        guard let previous = previous else {
            return current
        }
        let smoothedX = (current.x + previous.x) / 2
        let smoothedY = (current.y + previous.y) / 2
        return CGPoint(x: smoothedX, y: smoothedY)
    }
}
