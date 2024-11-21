//
//  test2.swift
//  Fleming_App
//
//  Created by 임유리 on 10/15/24.
//

import SwiftUI
import Vision
import AVFoundation

struct makeCameraView: UIViewControllerRepresentable {
    @Binding var pos: CGPoint?
    @Binding var imgPosition: CGPoint

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = camvc()
        viewController.pos = $pos
        viewController.imgPosition = $imgPosition
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

class camvc: UIViewController {
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var pos: Binding<CGPoint?>?
    var imgPosition: Binding<CGPoint>?
    private let handPoseRequest = VNDetectHumanHandPoseRequest()
    private var Array: [Data] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        Camera()
        select()
    }
    
    private func Camera() {
        setup()
        setupcam()
        setupOutput()
    }

    private func setup() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .high
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            print("Error")
            return
        }

        if captureSession?.canAddInput(input) == true {
            captureSession?.addInput(input)
        }
    }

    private func setupcam() {
        guard let session = captureSession else { return }
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.frame = view.bounds
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.connection?.videoOrientation = .landscapeRight
        if let layer = previewLayer {
            view.layer.addSublayer(layer)
        }
        session.startRunning()
    }

    private func setupOutput() {
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession?.addOutput(output)
    }
    
    private func select() {
        DispatchQueue.global(qos: .background).async {
            while true {
                let select = (1...100).map { ["id": $0, "value": UUID().uuidString] }
                if let selected = try? JSONSerialization.data(withJSONObject: select, options: []) {
                    self.Array.append(selected)
                }
                Thread.sleep(forTimeInterval: 0.2)
            }
        }
    }

}

extension camvc: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        try? perform(with: requestHandler)
    }
    
    private func perform(with handler: VNImageRequestHandler) {
        do {
            try handler.perform([handPoseRequest])
            guard let observation = handPoseRequest.results?.first else { return }

            let thumbPoints = try observation.recognizedPoints(.thumb)
            let indexPoints = try observation.recognizedPoints(.indexFinger)
            
            processHandPoints(thumbPoints, indexPoints)
        } catch {
            print("Error: \(error)")
        }
    }

    private func processHandPoints(_ thumbPoints: [VNHumanHandPoseObservation.JointName : VNRecognizedPoint],
                                   _ indexPoints: [VNHumanHandPoseObservation.JointName : VNRecognizedPoint]) {
        guard let thumbTip = thumbPoints[.thumbTip], let indexTip = indexPoints[.indexTip],
              thumbTip.confidence > 0.8, indexTip.confidence > 0.8 else { return }

        let thumbLocation = CGPoint(x: 1 - thumbTip.location.x, y: thumbTip.location.y)
        let indexLocation = CGPoint(x: 1 - indexTip.location.x, y: indexTip.location.y)

        let distance = hypot(thumbLocation.x - indexLocation.x, thumbLocation.y - indexLocation.y)
        update(thumbLocation: thumbLocation, indexLocation: indexLocation, distance: distance)
    }

    private func update(thumbLocation: CGPoint, indexLocation: CGPoint, distance: CGFloat) {
        DispatchQueue.main.async {
            guard let previewLayer = self.previewLayer else { return }

            let thumbConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: thumbLocation)
            let indexConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: indexLocation)

            if distance < 0.05 {
                           self.pos?.wrappedValue = indexConverted
                           self.updatepos(thumbConverted: thumbConverted, indexConverted: indexConverted)
                       } else {
                           self.pos?.wrappedValue = nil
                       }
                   }
               }

               private func updatepos(thumbConverted: CGPoint, indexConverted: CGPoint) {
                   let imageFrame = CGRect(x: self.imgPosition?.wrappedValue.x ?? 0, y: self.imgPosition?.wrappedValue.y ?? 0, width: 100, height: 100)
                   if imageFrame.contains(indexConverted) || imageFrame.contains(thumbConverted) {
                       let midpoint = CGPoint(x: (thumbConverted.x + indexConverted.x) / 2, y: (thumbConverted.y + indexConverted.y) / 2)
                       withAnimation(.easeInOut(duration: 0.2)) {
                           self.imgPosition?.wrappedValue = midpoint
                       }
                   }
               }
           }

