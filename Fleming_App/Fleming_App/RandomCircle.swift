//
//  RandomCircle.swift
//  Fleming_App
//
//  Created by 임유리 on 11/5/24.


import SwiftUI
import AVFoundation
import Vision

extension Color {
    static let customOrange = Color(hex: "#F4732B")
    static let customGreen = Color(hex: "77B723")
    static let customBrown = Color(hex: "795641")
}

struct RandomCircle: View {
    @State private var circlePositions: [(id: UUID, position: CGPoint, color: Color, size: CGFloat)] = []
    @State private var fingertipPosition: CGPoint? = nil
    @State private var showSuccess: Bool = false
    @State private var currentTouchedColor: Color? = nil
    @State private var lastTouchedCircle: (id: UUID, color: Color)? = nil
    @State private var lastTouchedCircleID: UUID? = nil
    @State private var fingerPath: [CGPoint] = []
    @State private var backgroundColors: [Color] = [Color.yellow.opacity(0.1)]
    
    private let circleCount = 6
    private let circleSize: CGFloat = 50.0
    private let colors: [Color] = [.customOrange, .customGreen, .customBrown]
    private let fingerCircleSize: CGFloat = 100.0
    
    var body: some View {
        ZStack {
            ForEach(backgroundColors.indices, id: \.self) { index in
                backgroundColors[index]
                    .ignoresSafeArea()
            }
            
            CameraView(fingertipPosition: $fingertipPosition)
                .ignoresSafeArea()
            
            Color.yellow.opacity(1.0)
                .ignoresSafeArea()
            
            ForEach(circlePositions, id: \.id) { item in
                Circle()
                    .frame(width: item.size, height: item.size)
                    .position(item.position)
                    .foregroundColor(item.color.opacity(1.0))
            }
            
            if let fingertipPosition = fingertipPosition {
                Image("handfinger")
                    .resizable()
                    .frame(width: fingerCircleSize, height: fingerCircleSize)
                    .position(fingertipPosition)
                    .onChange(of: fingertipPosition) { newPosition in
                        for _ in 0..<5 {
                            fingerPath.append(newPosition)
                        }
                        checkCircleCollision()
                    }
            }

            ForEach(0..<10, id: \.self) { _ in
                Path { path in
                    if !fingerPath.isEmpty {
                        path.move(to: fingerPath.first!)
                        for point in fingerPath.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                }
                .stroke(Color.red, lineWidth: 3)
            }

            

            if showSuccess {
                Text("Success")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.red)
                    .position(x: UIScreen.main.bounds.width / 2, y: 300)
                    .transition(.opacity)
            }
        }
        .onAppear {
            generateRandomCircles()
            startAddingColors()
        }
    }
    
    func generateRandomCircles() {
        let fixedPositions: [CGPoint] = [
            CGPoint(x: 150, y: 250),
            CGPoint(x: 250, y: 350),
            CGPoint(x: 510, y: 270),
            CGPoint(x: 450, y: 550),
            CGPoint(x: 690, y: 90),
            CGPoint(x: 420, y: 700)
        ]
        
        var generatedPositions: [(id: UUID, position: CGPoint, color: Color, size: CGFloat)] = []
        
        for (index, position) in fixedPositions.enumerated() {
            let color = colors[index / 2]
            let size = CGFloat(50.0)
            generatedPositions.append((id: UUID(), position: position, color: color, size: size))
        }
        
        circlePositions = generatedPositions
    }

    
    func distanceBetween(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
        return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2))
    }
    
    
    func checkCircleCollision() {
        guard let fingerPos = fingertipPosition else { return }
        
        let fingerImageSize: CGFloat = fingerCircleSize
        
        for circle in circlePositions {
            let distance = distanceBetween(circle.position, fingerPos)
            
            if distance < (circleSize / 2 + fingerImageSize / 2) {
                if currentTouchedColor == circle.color,
                   lastTouchedCircleID != circle.id {
                    showSuccess = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showSuccess = false
                    }
                }
                currentTouchedColor = circle.color
                lastTouchedCircleID = circle.id
                break
            }
        }
    }
    func startAddingColors() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            backgroundColors.append(Color.yellow.opacity(0.1))
            
            if backgroundColors.count > 1000 {
                timer.invalidate()
            }
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var fingertipPosition: CGPoint?
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        let captureSession = AVCaptureSession()
        
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: frontCamera) else {
            print("카메라 접근 오류")
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
                    print("손 탐색 에러 \(String(describing: error))")
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
                print("손가락 탐지 에러 \(error)")
            }
        }
        
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            guard let request = visionRequest else { return }
            do {
                try sequenceHandler.perform([request], on: sampleBuffer, orientation: .right)
            } catch {
                print("비전 요청 에러 \(error)")
            }
        }
    }
}

struct RandomCircle_Previews: PreviewProvider {
    static var previews: some View {
        RandomCircle()
    }
}
