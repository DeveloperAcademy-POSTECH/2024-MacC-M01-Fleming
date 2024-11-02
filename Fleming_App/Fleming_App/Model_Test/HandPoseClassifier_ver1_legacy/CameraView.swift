//
//  CameraView.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/23/24.
//

import SwiftUI
import AVFoundation
import Vision
import CoreML



//struct CameraView: UIViewControllerRepresentable {
//    @Binding var classificationLabel: String // Use this to display the classification
//    
//    func makeUIViewController(context: Context) -> UIViewController {
//        let viewController = UIViewController()
//        let captureSession = AVCaptureSession()
//        
//        // Set up the camera
//        guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
//            return viewController
//        }
//        
//        let videoInput: AVCaptureDeviceInput
//        do {
//            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
//        } catch {
//            return viewController
//        }
//        
//        if captureSession.canAddInput(videoInput) {
//            captureSession.addInput(videoInput)
//        } else {
//            return viewController
//        }
//
//        let videoOutput = AVCaptureVideoDataOutput()
//        videoOutput.setSampleBufferDelegate(context.coordinator, queue: DispatchQueue.global(qos: .userInitiated)) // Background thread
//        
//        if captureSession.canAddOutput(videoOutput) {
//            captureSession.addOutput(videoOutput)
//        } else {
//            return viewController
//        }
//        
//        // Adding camera preview layer to the view
//        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        previewLayer.videoGravity = .resizeAspectFill
//        previewLayer.frame = viewController.view.bounds
//        viewController.view.layer.addSublayer(previewLayer)
//        
//        // Start the camera session on a background thread
//        DispatchQueue.global(qos: .userInitiated).async {
//            captureSession.startRunning()
//        }
//        
//        return viewController
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
//        var parent: CameraView
//        let model: RockPaperScissors // Change to your actual model name
//        
//        init(_ parent: CameraView) {
//            self.parent = parent
//            do {
//                // Load the CoreML model
//                self.model = try RockPaperScissors(configuration: MLModelConfiguration())
//            } catch {
//                fatalError("Failed to load CoreML model: \(error)")
//            }
//        }
//        
//        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//
//            // Request for hand pose detection
//            let request = VNDetectHumanHandPoseRequest { (request, error) in
//                if let results = request.results as? [VNHumanHandPoseObservation], let firstHand = results.first {
//                    self.processHandPose(firstHand)
//                }
//            }
//            
//            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
//            do {
//                try handler.perform([request])
//            } catch {
//                print("Failed to perform hand pose request: \(error)")
//            }
//        }
//        
//        func processHandPose(_ observation: VNHumanHandPoseObservation) {
//            // Extract joint positions
//            guard let recognizedPoints = try? observation.recognizedPoints(.all) else {
//                print("No recognized points found")
//                return
//            }
//
//            // Print recognized points for debugging
//            print("Recognized Points: \(recognizedPoints)")
//
//            // Extract the recognized joint points and form an array of CGPoints
//            var jointPositions = [CGPoint]()
//            for (jointName, recognizedPoint) in recognizedPoints {
//                jointPositions.append(recognizedPoint.location)
//                print("Joint \(jointName.rawValue): \(recognizedPoint.location)") // Debugging: Print each joint's position
//            }
//            
//            // Make sure we have the correct number of points (model expects 21 keypoints)
//            guard jointPositions.count == 21 else {
//                print("Insufficient joint points detected: \(jointPositions.count) points found")
//                return
//            }
//
//            // Prepare input for CoreML model
//            guard let mlMultiArray = try? MLMultiArray(shape: [1, 21, 3], dataType: .float32) else {
//                print("Failed to create MLMultiArray")
//                return
//            }
//            for (index, point) in jointPositions.enumerated() {
//                mlMultiArray[index] = NSNumber(value: Float(point.x))
//                mlMultiArray[index + 21] = NSNumber(value: Float(point.y)) // Assuming 3D coordinates
//                mlMultiArray[index + 42] = NSNumber(value: 0.0) // Assuming z-coordinates are not used
//            }
//
//            // Predict using CoreML
//            do {
//                let modelInput = RockPaperScissorsInput(poses: mlMultiArray)
//                let prediction = try model.prediction(input: modelInput)
//
//                // Update the classification label on the main thread
//                DispatchQueue.main.async {
//                    self.parent.classificationLabel = prediction.label
//                }
//            } catch {
//                print("Prediction failed: \(error)")
//            }
//        }
//    }
//}

// https://medium.com/codex/how-to-use-vision-hand-pose-in-swiftui-a24b7a7e5721



// https://www.hackingwithswift.com/books/ios-swiftui/connecting-swiftui-to-core-ml
//import SwiftUI
//import Vision
//import CoreML
//
//public protocol UIViewControllerRepresentable : View where Self.Body == Never {
//    func makeUIViewController(context: Self.Context) -> Self.UIViewControllerType
//
//}
//
//struct CameraView: UIViewControllerRepresentable {
//    var model: HandPoseClassifier! // Your CoreML Model
//    var activityItems: [Any]
//      var applicationActivities: [UIActivity]? = nil
//      
//      func makeUIViewController(context: UIViewControllerRepresentableContext<MyActivityView>) -> UIActivityViewController {
//        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
//      }
//      
//      func updateUIViewController(
//        _ uiViewController: UIActivityViewController,
//        context: UIViewControllerRepresentableContext<MyActivityView>
//      ) {}
//    }
//
//class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
//    var onPrediction: ((String) -> Void)?
//    let handPoseRequest = VNDetectHumanHandPoseRequest()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Setup Camera, AVCaptureSession, etc.
//    }
//
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
//        try? handler.perform([handPoseRequest])
//
//        guard let observation = handPoseRequest.results?.first else { return }
//        let handPoints = try? observation.recognizedPoints(.all) // All hand points
//
//        // Convert to MLMultiArray, then call model for prediction
//        if let multiArray = handPointsToMultiArray(handPoints) {
//            let prediction = try? model.prediction(poses: multiArray)
//            let label = prediction?.label ?? "Unknown"
//            DispatchQueue.main.async {
//                self.onPrediction?(label)
//            }
//        }
//    }
//
//    func handPointsToMultiArray(_ points: [VNRecognizedPointKey: VNRecognizedPoint]) -> MLMultiArray? {
//        // Convert points to MLMultiArray expected by the Core ML model
//    }
//}
