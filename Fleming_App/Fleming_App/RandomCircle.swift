//
//  RandomCircle.swift
//  Fleming_App
//
//  Created by 임유리 on 11/5/24.
//

import SwiftUI
import AVFoundation

struct RandomCircle: View {
    @State private var circlePositions: [CGPoint] = []
    private let circleCount = 6
    private let circleSize: CGFloat = 50.0

    var body: some View {
        ZStack {
            CameraView()
                .ignoresSafeArea()

            ForEach(circlePositions, id: \.self) { position in
                Circle()
                    .frame(width: circleSize, height: circleSize)
                    .position(position)
                    .foregroundColor(.blue.opacity(0.7))
            }
        }
        .onAppear(perform: generateRandomCircles)
    }

    func generateRandomCircles() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        var generatedPositions: [CGPoint] = []

        while generatedPositions.count < circleCount {
            let x = CGFloat.random(in: circleSize...(screenWidth - circleSize))
            let y = CGFloat.random(in: circleSize...(screenHeight - circleSize))
            let newPoint = CGPoint(x: x, y: y)

            if !generatedPositions.contains(where: { point in
                distanceBetween(point, newPoint) < circleSize
            }) {
                generatedPositions.append(newPoint)
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
        let cameraLayer = AVCaptureVideoPreviewLayer(session: AVCaptureSession())
        cameraLayer.videoGravity = .resizeAspectFill
        controller.view.layer.addSublayer(cameraLayer)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}
