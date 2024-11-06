//
//  RandomCircle.swift
//  Fleming_App
//
//  Created by 임유리 on 11/5/24.
//
//카메라 좌표 변경 예정

import SwiftUI
import AVFoundation

///Conformance of 'CGPoint' to 'Hashable' is only available in iOS 18.0 or newer; this is an error in the Swift 6 language mode
///hashtable프로토콜 준수는 ios 18이상에서만 지원되어서 수정 완료

struct RandomCircle: View {
    @State private var circlePositions: [(id: UUID, position: CGPoint, color: Color)] = []
    private let circleCount = 6
    private let circleSize: CGFloat = 50.0
    private let colors: [Color] = [.red, .blue, .green]  // 각 색상마다 2개씩 생성
    private let margin: CGFloat = 50.0 //여백 위해
    var body: some View {
        ZStack {
            CameraView()
                .ignoresSafeArea()

            ForEach(circlePositions, id: \.id) { item in
                Circle()
                    .frame(width: circleSize, height: circleSize)
                    .position(item.position)
                    .foregroundColor(item.color.opacity(0.7))
            }
        }
        .onAppear(perform: generateRandomCircles)
    }

    func generateRandomCircles() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        var generatedPositions: [(id: UUID, position: CGPoint, color: Color)] = []

        while generatedPositions.count < circleCount {
            // 가장자리에 닿지 않도록 수정
            let x = CGFloat.random(in: (circleSize + margin)...(screenWidth - circleSize - margin))
            let y = CGFloat.random(in: (circleSize + margin)...(screenHeight - circleSize - margin))
            let newPoint = CGPoint(x: x, y: y)

            if !generatedPositions.contains(where: { point in
                distanceBetween(point.position, newPoint) < circleSize
            }) {
                // 두 개씩 같은 색을 할당 위해 작성
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
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        let captureSession = AVCaptureSession()
        
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: frontCamera) else {
            print("Failed to access front camera.")
            return controller
        }
        
        captureSession.addInput(input)
        
        let cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraLayer.videoGravity = .resizeAspectFill
        cameraLayer.frame = controller.view.bounds
        controller.view.layer.addSublayer(cameraLayer)
        
        captureSession.startRunning()
        
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}
