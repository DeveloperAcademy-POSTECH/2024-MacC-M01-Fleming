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
    
    @Binding var touchPoint: CGPoint?
    @Binding var imgPosition: CGPoint

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = CameraViewController()
        viewController.touchPoint = $touchPoint
        viewController.imgPosition = $imgPosition
        return viewController
    }
}

class CameraViewController: UIViewController {
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var touchPoint: Binding<CGPoint?>?
    var imgPosition: Binding<CGPoint>?

    private let handPoseRequest = VNDetectHumanHandPoseRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }
    
    func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .high
        
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("에러.")
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
            print("오류 발생: \(error)")
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
            
            let thumbPoints = try observation.recognizedPoints(.thumb)
            let indexFingerPoints = try observation.recognizedPoints(.indexFinger)
            
            if let thumbTip = thumbPoints[.thumbTip], let indexTip = indexFingerPoints[.indexTip],
               thumbTip.confidence > 0.8 && indexTip.confidence > 0.8 {

                let thumbTipLocation = CGPoint(x: 1 - thumbTip.location.x, y: thumbTip.location.y)
                let indexTipLocation = CGPoint(x: 1 - indexTip.location.x, y: indexTip.location.y)

                let distance = hypot(thumbTipLocation.x - indexTipLocation.x, thumbTipLocation.y - indexTipLocation.y)

                if distance < 0.05 {
                    DispatchQueue.main.async {
                        if let previewLayer = self.previewLayer {
                            let convertedThumbPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: thumbTipLocation)
                            let convertedIndexPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: indexTipLocation)

                            self.touchPoint?.wrappedValue = convertedIndexPoint
                            let imgFrame = CGRect(x: self.imgPosition?.wrappedValue.x ?? 0, y: self.imgPosition?.wrappedValue.y ?? 0, width: 100, height: 100)
                            if imgFrame.contains(convertedIndexPoint) || imgFrame.contains(convertedThumbPoint) {
                                let middlePoint = CGPoint(x: (convertedThumbPoint.x + convertedIndexPoint.x) / 2,
                                                          y: (convertedThumbPoint.y + convertedIndexPoint.y) / 2)

                                withAnimation(.easeInOut(duration: 0.2)) {
                                    self.imgPosition?.wrappedValue = middlePoint
                                }
                                
                                
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
}
