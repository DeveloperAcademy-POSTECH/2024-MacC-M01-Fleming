//
//  ThreeLittlePigs10.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/14/24.
//


import SwiftUI
import Vision
import AVFoundation

//
//  makeCameraView.swift
//  Fleming_App
//
//  Created by 임유리 on 10/14/24.
//

//struct makeCameraView: UIViewControllerRepresentable {
//    
//    @Binding var touchPoint: CGPoint? // 엄지와 검지가 맞닿은 지점
//    @Binding var imgPosition: CGPoint // 이미지의 현재 위치
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        let viewController = CameraViewController()
//        viewController.touchPoint = $touchPoint
//        viewController.imgPosition = $imgPosition
//        return viewController
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
//}
//
//class CameraViewController: UIViewController {
//    var captureSession: AVCaptureSession?
//    var previewLayer: AVCaptureVideoPreviewLayer?
//    var touchPoint: Binding<CGPoint?>?
//    var imgPosition: Binding<CGPoint>?
//
//    private let handPoseRequest = VNDetectHumanHandPoseRequest()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupCamera()
//    }
//    
//    func setupCamera() {
//        captureSession = AVCaptureSession()
//        captureSession?.sessionPreset = .high
//        
//        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
//            print("전면 카메라를 찾을 수 없음.")
//            return
//        }
//        
//        do {
//            let input = try AVCaptureDeviceInput(device: frontCamera)
//            if captureSession?.canAddInput(input) == true {
//                captureSession?.addInput(input)
//            }
//            
//            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
//            previewLayer?.frame = view.bounds
//            previewLayer?.videoGravity = .resizeAspectFill
//            view.layer.addSublayer(previewLayer!)
//            
//            captureSession?.startRunning()
//            
//            let output = AVCaptureVideoDataOutput()
//            output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
//            captureSession?.addOutput(output)
//        } catch {
//            print("전면 카메라 설정 중 오류 발생: \(error)")
//        }
//    }
//}
//
//extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//        
//        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
//        do {
//            try requestHandler.perform([handPoseRequest])
//            guard let observation = handPoseRequest.results?.first else { return }
//            
//            // 엄지와 검지의 위치를 추출
//            let thumbPoints = try observation.recognizedPoints(.thumb)
//            let indexFingerPoints = try observation.recognizedPoints(.indexFinger)
//            
//            if let thumbTip = thumbPoints[.thumbTip], let indexTip = indexFingerPoints[.indexTip],
//               thumbTip.confidence > 0.8 && indexTip.confidence > 0.8 {
//                
//                // 엄지와 검지 좌표 확인
//                print("Thumb: \(thumbTip.location), Index: \(indexTip.location)")
//                
//                // Vision 좌표는 (0,0)이 좌측 하단
//                //(1,1)이 우측 상단
//                let thumbTipLocation = CGPoint(x: thumbTip.location.x, y: 1 - thumbTip.location.y)
//                let indexTipLocation = CGPoint(x: indexTip.location.x, y: 1 - indexTip.location.y)
//                
//                // 엄지와 검지의 거리를 계산하여 맞닿았는지 확인
//                let distance = hypot(thumbTipLocation.x - indexTipLocation.x, thumbTipLocation.y - indexTipLocation.y)
//                
//                // 맞닿았다면 화면 좌표로 변환하여 전달
//                // 일정 거리 이하일 경우에,
//                if distance < 0.05 {
//                    DispatchQueue.main.async {
//                        if let previewLayer = self.previewLayer {
//                            // 카메라 좌표를 화면 좌표로 변환
//                            let convertedThumbPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: thumbTipLocation)
//                            let convertedIndexPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: indexTipLocation)
//                            
//                            // 검지의 좌표를 사용하여 원을 그리도록 업데이트
//                            self.touchPoint?.wrappedValue = convertedIndexPoint
//                            // 엄지와 검지가 img에 닿으면 img 위치를 업데이트
//                            let imgFrame = CGRect(x: self.imgPosition?.wrappedValue.x ?? 0, y: self.imgPosition?.wrappedValue.y ?? 0, width: 100, height: 100)
//                            if imgFrame.contains(convertedIndexPoint) || imgFrame.contains(convertedThumbPoint) {
//                                let middlePoint = CGPoint(x: (convertedThumbPoint.x + convertedIndexPoint.x) / 2,
//                                                          y: (convertedThumbPoint.y + convertedIndexPoint.y) / 2)
//                                self.imgPosition?.wrappedValue = middlePoint
//                            }
//                        }
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        self.touchPoint?.wrappedValue = nil
//                    }
//                }
//            }
//        } catch {
//            print("에러 \(error)")
//        }
//    }
//}



struct ThreeLittlePigs10: View {
    
    //By Hera
    @State private var touchPoint: CGPoint? = nil
    @State private var imgPosition: CGPoint = CGPoint(x: 300, y: 620) // 초기 이미지 위치 //x는 950으로 y는 620이 correct
    
    @Binding var currentStep: Int
    // currentStep 스토리 진행의 단계를 나타낸다

    @Binding var isLeft : Bool // 동그라미가 왼쪽에 있는지 여부
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect() // 0.5초 간격 타이머

    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    @State private var isSuccess = false // 성공 여부를 나타내는 상태값
    
    var body: some View {
        
        ZStack{
            // 카메라 뷰
//            CameraView_ThreeLittlePig(touchPoint: $touchPoint, imgPosition: $imgPosition,currentStep:$currentStep)
                //.edgesIgnoringSafeArea(.all)
            
            //makeCameraView(touchPoint: $touchPoint, imgPosition: $imgPosition).edgesIgnoringSafeArea(.all)
            
            makeCameraView(touchPoint: $touchPoint, imgPosition: $imgPosition).edgesIgnoringSafeArea(.all)
//                .rotationEffect(.degrees(-90))
            
            
            // 캐릭터 위치
            HStack{
                Image("character_pig1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.1) // 화면 크기 n배
                    .offset(x: isLeft ? -300 : -250, y: 200) // 좌우로 이동
                    .animation(.easeInOut(duration: 0.8), value: isLeft) // 0.5초 간격 애니메이션
                    .onReceive(timer) { _ in
                        // 0.5초마다 좌우 위치를 변경
                        isLeft.toggle()
                    }
                
                Image("character_pig2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.1) // 화면 크기 n배
                    .offset(x: isLeft ? -230 : -210, y: 180)
                    .animation(.easeInOut(duration: 0.2), value: isLeft) // 0.5초 간격 애니메이션
                    .onReceive(timer) { _ in
                        // 0.5초마다 좌우 위치를 변경
                        isLeft.toggle()
                    }
                
                Image("character_pig3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.1) // 화면 크기 n배
                    .offset(x: isLeft ? -200 : -170, y: 170)
                    .animation(.easeInOut(duration: 0.3), value: isLeft) // 0.5초 간격 애니메이션
                    .onReceive(timer) { _ in
                        // 0.5초마다 좌우 위치를 변경
                        isLeft.toggle()
                    }
            }
            .offset(x: -250)
            
            // 각각 분리형 집
//            Image("object_home11_in")
//                .resizable()
//                .scaledToFit()
//                .frame(width: UIScreen.main.bounds.width * 0.3) // 화면 크기 n배
//                .offset(x: -260, y: 100)
            
            Image("object_home11_cut")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.3) // 화면 크기 n배
                .offset(x: 260, y: 100)
            
            GeometryReader { geometry in
                Image("object_home11_in") // testimg 파일을 표시
                    .resizable()
                    .scaledToFit()
                //.frame(width: 100, height: 100) // 이미지 크기
                    .frame(width: UIScreen.main.bounds.width * 0.1) // 화면 크기 n배
                //                    .position(x: geometry.size.width * 0.1, // 왼쪽 중앙에 배치
                //                              y: geometry.size.height * 0.5)
                // 이동할 수 있도록
                    .position(imgPosition)
                    .onChange(of: imgPosition) { newPosition in
                        // 목표 위치: x가 950 근방, y가 620 근방
                        let targetX: CGFloat = 950
                        let targetY: CGFloat = 620
                        
                        // 변경된 위치가 목표 위치와 가까워지면 isSuccess를 true
                        if abs(newPosition.x - targetX) < 50 && abs(newPosition.y - targetY) < 50 {
                            withAnimation {
                                isSuccess = true
                            }
                        }
                    }
            }
            
            // 손가락이 맞닿았을 때 원 그리기
            if let touchPoint = touchPoint {
                Circle()
                    .fill(Color.red)
                    .frame(width: 30, height: 30)
                    .position(touchPoint)
            }
            
            // 성공 메시지 표시
            if isSuccess {
                Text("Success!")
                    .font(.title)
                    .foregroundColor(.red)
                    .bold()
                    .position(x: screenWidth / 2, y: screenHeight / 2)
                    .animation(.easeInOut(duration: 3), value: isSuccess)
            }
                
        }
    }
}

//#Preview {
//    @Previewable @State var isLeft: Bool = false
//    ThreeLittlePigs10(currentStep: .constant(10), isLeft:$isLeft)
//}
