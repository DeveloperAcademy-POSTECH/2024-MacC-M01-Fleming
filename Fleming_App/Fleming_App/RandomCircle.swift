//
//  RandomCircle.swift
//  Fleming_App
//
//  Created by 임유리 on 11/5/24.
//
//카메라 좌표 변경 예정
//
//import SwiftUI
//import AVFoundation
//
//
/////Conformance of 'CGPoint' to 'Hashable' is only available in iOS 18.0 or newer; this is an error in the Swift 6 language mode
/////hashtable프로토콜 준수는 ios 18이상에서만 지원되어서 수정 완료
//
//struct RandomCircle: View {
//    @State private var circlePositions: [(id: UUID, position: CGPoint, color: Color)] = []
//    private let circleCount = 6
//    private let circleSize: CGFloat = 50.0
//    private let colors: [Color] = [.red, .blue, .green]  // 각 색상마다 2개씩 생성
//    private let margin: CGFloat = 50.0 //여백 위해
//    var body: some View {
//        ZStack {
//            CameraView()
//                .ignoresSafeArea()
//
//            Color.yellow.opacity(0.7)
//                        .ignoresSafeArea()
//            
//            ForEach(circlePositions, id: \.id) { item in
//                Circle()
//                    .frame(width: circleSize, height: circleSize)
//                    .position(item.position)
//                    .foregroundColor(item.color.opacity(0.7))
//            }
//        }
//        .onAppear(perform: generateRandomCircles)
//    }
//
//    func generateRandomCircles() {
//        let screenWidth = UIScreen.main.bounds.width
//        let screenHeight = UIScreen.main.bounds.height
//        var generatedPositions: [(id: UUID, position: CGPoint, color: Color)] = []
//
//        while generatedPositions.count < circleCount {
//            // 가장자리에 닿지 않도록 수정
//            let x = CGFloat.random(in: (circleSize + margin)...(screenWidth - circleSize - margin))
//            let y = CGFloat.random(in: (circleSize + margin)...(screenHeight - circleSize - margin))
//            let newPoint = CGPoint(x: x, y: y)
//
//            if !generatedPositions.contains(where: { point in
//                distanceBetween(point.position, newPoint) < circleSize
//            }) {
//                // 두 개씩 같은 색을 할당 위해 작성
//                let color = colors[generatedPositions.count / 2]
//                generatedPositions.append((id: UUID(), position: newPoint, color: color))
//            }
//        }
//        
//        circlePositions = generatedPositions
//    }
//
//    //원과 원끼리 닿지 않도록
//    func distanceBetween(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
//        return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2))
//    }
//}
//
//struct CameraView: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> UIViewController {
//        let controller = UIViewController()
//        let captureSession = AVCaptureSession()
//        
//        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
//              let input = try? AVCaptureDeviceInput(device: frontCamera) else {
//            print("Failed to access front camera.")
//            return controller
//        }
//        
//        captureSession.addInput(input)
//        
//        let cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        cameraLayer.videoGravity = .resizeAspectFill
//        cameraLayer.frame = controller.view.bounds
//        
//        cameraLayer.setAffineTransform(CGAffineTransform(rotationAngle: -.pi / 2))
//        //카메라 회전 위해 -> 왼쪽으로 90도
//        
//        controller.view.layer.addSublayer(cameraLayer)
//        
//        //화면 크기가 변할 때 레이어의 크기도
//        DispatchQueue.main.async {
//            cameraLayer.frame = controller.view.bounds
//        }
//        
//        captureSession.startRunning()
//        
//        return controller
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        if let cameraLayer = uiViewController.view.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
//            cameraLayer.frame = uiViewController.view.bounds // 화면 크기에 맞춰 재조정
//        }
//    }
//}
//
//
//
//import SwiftUI
//import AVFoundation
//import Vision
//
//struct RandomCircle: View {
//    @State private var circlePositions: [(id: UUID, position: CGPoint, color: Color)] = []
//    @State private var fingertipPosition: CGPoint? = nil
//    @State private var showSuccess: Bool = false
//    
//    private let circleCount = 6
//    private let circleSize: CGFloat = 50.0
//    private let colors: [Color] = [.red, .blue, .green]
//    private let margin: CGFloat = 50.0
//    private let fingerCircleSize: CGFloat = 30.0
//    
//   // @State private var fingertipPosition: CGPoint? = nil
//    
//    var body: some View {
//            ZStack {
//                CameraView(fingertipPosition: $fingertipPosition)
//                    .ignoresSafeArea()
//                
//                Color.yellow.opacity(0.7)
//                    .ignoresSafeArea()
//                
//                ForEach(circlePositions, id: \.id) { item in
//                    Circle()
//                        .frame(width: circleSize, height: circleSize)
//                        .position(item.position)
//                        .foregroundColor(item.color.opacity(0.7))
//                }
//                
//                if let fingertipPosition = fingertipPosition {
//                    Circle()
//                        .frame(width: fingerCircleSize, height: fingerCircleSize)
//                        .position(fingertipPosition)
//                        .foregroundColor(.red)
//                        .onChange(of: fingertipPosition) { _ in
//                            checkRedCircleCollision()
//                        }
//                }
//                
//                if showSuccess {
//                    Text("Success!")
//                        .font(.largeTitle)
//                        .bold()
//                        .foregroundColor(.green)
//                }
//            }
//            .onAppear(perform: generateRandomCircles)
//        }
//    
//    func checkRedCircleCollision() {
//          guard let fingerPos = fingertipPosition else { return }
//          
//          // 빨간색 원들의 위치를 찾습니다
//          let redCircles = circlePositions.filter { $0.color == .red }
//          var touchingRedCircles = 0
//          
//          for redCircle in redCircles {
//              let distance = distanceBetween(redCircle.position, fingerPos)
//              // 손가락 원의 반지름(fingerCircleSize/2)과 빨간 원의 반지름(circleSize/2)의 합보다
//              // 거리가 작으면 충돌로 간주
//              if distance < (circleSize/2 + fingerCircleSize/2) {
//                  touchingRedCircles += 1
//              }
//          }
//          
//          // 두 개의 빨간 원을 동시에 터치했을 때
//          if touchingRedCircles == 2 {
//              showSuccess = true
//              // 2초 후에 Success 메시지를 숨깁니다
//              DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                  showSuccess = false
//              }
//          }
//      }
//    
//    func generateRandomCircles() {
//        let screenWidth = UIScreen.main.bounds.width
//        let screenHeight = UIScreen.main.bounds.height
//        var generatedPositions: [(id: UUID, position: CGPoint, color: Color)] = []
//        
//        while generatedPositions.count < circleCount {
//            let x = CGFloat.random(in: (circleSize + margin)...(screenWidth - circleSize - margin))
//            let y = CGFloat.random(in: (circleSize + margin)...(screenHeight - circleSize - margin))
//            let newPoint = CGPoint(x: x, y: y)
//            
//            if !generatedPositions.contains(where: { point in
//                distanceBetween(point.position, newPoint) < circleSize
//            }) {
//                let color = colors[generatedPositions.count / 2]
//                generatedPositions.append((id: UUID(), position: newPoint, color: color))
//            }
//        }
//        
//        circlePositions = generatedPositions
//    }
//    
//    func distanceBetween(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
//        return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2))
//    }
//}
//
//struct CameraView: UIViewControllerRepresentable {
//    @Binding var fingertipPosition: CGPoint?
//    
//    func makeUIViewController(context: Context) -> UIViewController {
//        let controller = UIViewController()
//        let captureSession = AVCaptureSession()
//        
//        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
//              let input = try? AVCaptureDeviceInput(device: frontCamera) else {
//            print("Failed to access front camera.")
//            return controller
//        }
//        
//        captureSession.addInput(input)
//        
//        let videoOutput = AVCaptureVideoDataOutput()
//        videoOutput.setSampleBufferDelegate(context.coordinator, queue: DispatchQueue(label: "videoQueue"))
//        captureSession.addOutput(videoOutput)
//        
//        let cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        cameraLayer.videoGravity = .resizeAspectFill
//        cameraLayer.frame = controller.view.bounds
//        cameraLayer.setAffineTransform(CGAffineTransform(rotationAngle: -.pi / 2))
//        
//        controller.view.layer.addSublayer(cameraLayer)
//        
//        DispatchQueue.main.async {
//            cameraLayer.frame = controller.view.bounds
//        }
//        
//        captureSession.startRunning()
//        context.coordinator.setupVisionRequest()
//        
//        return controller
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        if let cameraLayer = uiViewController.view.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
//            cameraLayer.frame = uiViewController.view.bounds
//        }
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(fingertipPosition: $fingertipPosition)
//    }
//    
//    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
//        @Binding var fingertipPosition: CGPoint?
//        private var visionRequest: VNRequest?
//        private var sequenceHandler = VNSequenceRequestHandler()
//        
//        init(fingertipPosition: Binding<CGPoint?>) {
//            _fingertipPosition = fingertipPosition
//        }
//        
//        func setupVisionRequest() {
//            let handPoseRequest = VNDetectHumanHandPoseRequest { [weak self] request, error in
//                guard error == nil else {
//                    print("Hand pose detection error: \(String(describing: error))")
//                    return
//                }
//                
//                if let observations = request.results as? [VNHumanHandPoseObservation] {
//                    self?.processHandPoseObservations(observations)
//                }
//            }
//            self.visionRequest = handPoseRequest
//        }
//        
//        func processHandPoseObservations(_ observations: [VNHumanHandPoseObservation]) {
//            guard let observation = observations.first else { return }
//            
//            do {
//                let indexFingerPoints = try observation.recognizedPoints(.indexFinger)
//                
//                guard let indexTipPoint = indexFingerPoints[.indexTip],
//                      indexTipPoint.confidence > 0.3 else {
//                    return
//                }
//                
//                let screenBounds = UIScreen.main.bounds
//                let point = CGPoint( //여기서 좌표값 수정..
//                    x: (1 - indexTipPoint.location.y) * screenBounds.width,
//                    y: (indexTipPoint.location.x) * screenBounds.height
//                )
//                
//                DispatchQueue.main.async {
//                    self.fingertipPosition = point
//                }
//            } catch {
//                print("Error detecting index finger tip: \(error)")
//            }
//        }
//        
//        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//            guard let request = visionRequest else { return }
//            do {
//                try sequenceHandler.perform([request], on: sampleBuffer, orientation: .right)
//            } catch {
//                print("Vision request failed: \(error)")
//            }
//        }
//    }
//}
//
//struct RandomCircle_Previews: PreviewProvider {
//    static var previews: some View {
//        RandomCircle()
//    }
//}
//


import SwiftUI
import AVFoundation
import Vision

struct RandomCircle: View {
    @State private var circlePositions: [(id: UUID, position: CGPoint, color: Color)] = []
    @State private var fingertipPosition: CGPoint? = nil
    @State private var showSuccess: Bool = false
    @State private var fingertipTouchingCircle: Bool = false
    
    private let circleCount = 6
    private let circleSize: CGFloat = 50.0
    private let colors: [Color] = [.red, .blue, .green]
    private let margin: CGFloat = 100.0
    private let fingerCircleSize: CGFloat = 50.0
    
    var body: some View {
        ZStack {
            CameraView(fingertipPosition: $fingertipPosition)
                .ignoresSafeArea()
            
            Color.yellow.opacity(0.7)
                .ignoresSafeArea()
            
            ForEach(circlePositions, id: \.id) { item in
                Circle()
                    .frame(width: circleSize, height: circleSize)
                    .position(item.position)
                    .foregroundColor(item.color.opacity(0.7))
            }
            
            if let fingertipPosition = fingertipPosition {
                Circle()
                    .frame(width: fingerCircleSize, height: fingerCircleSize)
                    .position(fingertipPosition)
                    .foregroundColor(.red)
                    .onChange(of: fingertipPosition) { _ in
                        checkCircleCollision()
                    }
            }
            
            if fingertipTouchingCircle {
                Text("원에 닿음")
                    .font(.title)
                    .bold()
                    .foregroundColor(.green)
                    .padding()
            }
            
            if showSuccess {
                Text("Success!")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.green)
            }
        }
        .onAppear(perform: generateRandomCircles)
    }
    
    func checkCircleCollision() {
        guard let fingerPos = fingertipPosition else { return }
        
        var touchingCircles = 0
        
        for circle in circlePositions {
            let distance = distanceBetween(circle.position, fingerPos)
            if distance < (circleSize / 2 + fingerCircleSize / 2) {
                touchingCircles += 1
            }
        }
        
        fingertipTouchingCircle = touchingCircles > 0
        
        let redCircles = circlePositions.filter { $0.color == .red }
        var touchingRedCircles = 0
        
        for redCircle in redCircles {
            let distance = distanceBetween(redCircle.position, fingerPos)
            if distance < (circleSize / 2 + fingerCircleSize / 2) {
                touchingRedCircles += 1
            }
        }
        
        if touchingRedCircles == 2 {
            showSuccess = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showSuccess = false
            }
        }
    }
    
    func generateRandomCircles() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        var generatedPositions: [(id: UUID, position: CGPoint, color: Color)] = []
        
        while generatedPositions.count < circleCount {
            let x = CGFloat.random(in: (circleSize + margin)...(screenWidth - circleSize - margin))
            let y = CGFloat.random(in: (circleSize + margin)...(screenHeight - circleSize - margin))
            let newPoint = CGPoint(x: x, y: y)
            
            if !generatedPositions.contains(where: { point in
                distanceBetween(point.position, newPoint) < circleSize
            }) {
                let color = colors[generatedPositions.count / 2]
                generatedPositions.append((id: UUID(), position: newPoint, color: color))
            }
        }
        
        circlePositions = generatedPositions
    }
    
    func distanceBetween(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
        return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2))
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var fingertipPosition: CGPoint?
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        let captureSession = AVCaptureSession()
        
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: frontCamera) else {
            print("카메라 접근 에러")
            return controller
        }
        
        captureSession.addInput(input)
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(context.coordinator, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(videoOutput)
        
        let cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraLayer.videoGravity = .resizeAspectFill
        cameraLayer.frame = controller.view.bounds
        cameraLayer.setAffineTransform(CGAffineTransform(rotationAngle: -.pi / 2))
        
        controller.view.layer.addSublayer(cameraLayer)
        
        DispatchQueue.main.async {
            cameraLayer.frame = controller.view.bounds
        }
        
        captureSession.startRunning()
        context.coordinator.setupVisionRequest()
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let cameraLayer = uiViewController.view.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            cameraLayer.frame = uiViewController.view.bounds
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(fingertipPosition: $fingertipPosition)
    }
    
    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        @Binding var fingertipPosition: CGPoint?
        private var visionRequest: VNRequest?
        private var sequenceHandler = VNSequenceRequestHandler()
        
        init(fingertipPosition: Binding<CGPoint?>) {
            _fingertipPosition = fingertipPosition
        }
        
        func setupVisionRequest() {
            let handPoseRequest = VNDetectHumanHandPoseRequest { [weak self] request, error in
                guard error == nil else {
                    print("핸드포즈 찾기 에러 \(String(describing: error))")
                    return
                }
                
                if let observations = request.results as? [VNHumanHandPoseObservation] {
                    self?.processHandPoseObservations(observations)
                }
            }
            self.visionRequest = handPoseRequest
        }
        
        func processHandPoseObservations(_ observations: [VNHumanHandPoseObservation]) {
            guard let observation = observations.first else { return }
            
            do {
                let indexFingerPoints = try observation.recognizedPoints(.indexFinger)
                
                guard let indexTipPoint = indexFingerPoints[.indexTip],
                      indexTipPoint.confidence > 0.3 else {
                    return
                }
                
                let screenBounds = UIScreen.main.bounds
                let point = CGPoint(
                    x: (1 - indexTipPoint.location.y) * screenBounds.width,
                    y: (indexTipPoint.location.x) * screenBounds.height
                )
                
                DispatchQueue.main.async {
                    self.fingertipPosition = point
                }
            } catch {
                print("찾기 에러: \(error)")
            }
        }
        
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            guard let request = visionRequest else { return }
            do {
                try sequenceHandler.perform([request], on: sampleBuffer, orientation: .right)
            } catch {
                print("비전 에러 \(error)")
            }
        }
    }
}

struct RandomCircle_Previews: PreviewProvider {
    static var previews: some View {
        RandomCircle()
    }
}
