//
//  HandPoseView.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/23/24.
//

//import SwiftUI
//import AVFoundation
//import Vision
//
//struct HandPoseView: UIViewControllerRepresentable {
//    
//    @Binding var classifiedPose: String
//    
//    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
//        var parent: HandPoseView
//        
//        init(parent: HandPoseView) {
//            self.parent = parent
//        }
//        
//        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//            print("captureOutput 호출됨: 프레임이 수신됨")
//            
//            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
//                print("captureOutput: pixelBuffer is nil")
//                return
//            }
//            
//            // 포즈 추정을 위한 요청 생성
//            let request = VNDetectHumanBodyPoseRequest { request, error in
//                if let results = request.results as? [VNHumanBodyPoseObservation] {
//                    for observation in results {
//                        // 관절 좌표 추출 (JointName을 RecognizedPointKey로 변환)
//                        let joints = observation.availableJointNames.compactMap { jointName -> (VNRecognizedPointKey, VNRecognizedPoint)? in
//                            guard let point = try? observation.recognizedPoint(jointName) else { return nil }
//                            let recognizedPointKey = VNRecognizedPointKey(rawValue: jointName.rawValue.rawValue)
//                            return (recognizedPointKey, point)
//                        }
//                        
//                        let jointsDict = Dictionary(uniqueKeysWithValues: joints)
//                        
//                        // 추출된 관절 좌표를 PoseClassifier로 전달하여 동작 분류
//                        let classifiedPose = PoseClassifierModel.shared.classifyPose(joints: jointsDict)
//                        DispatchQueue.main.async {
//                            self.parent.classifiedPose = classifiedPose
//                        }
//                    }
//                }
//            }
//            
//            // Vision 요청 핸들러
//            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
//            do {
//                try handler.perform([request])
//            } catch {
//                print("Failed to perform pose request: \(error)")
//            }
//        }
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(parent: self)
//    }
//    
//    func makeUIViewController(context: Context) -> UIViewController {
//        let viewController = UIViewController()
//        print("makeUIViewController: ViewController 생성됨")
//        
//        let captureSession = AVCaptureSession()
//        captureSession.sessionPreset = .high
//        print("makeUIViewController: CaptureSession 생성됨")
//        
//        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
//            print("No front camera available")
//            return viewController
//        }
//        
//        do {
//            let input = try AVCaptureDeviceInput(device: captureDevice)
//            captureSession.addInput(input)
//            print("makeUIViewController: Input 추가됨")
//        } catch {
//            print("Error setting device input: \(error)")
//            return viewController
//        }
//        
//        let videoOutput = AVCaptureVideoDataOutput()
//        videoOutput.setSampleBufferDelegate(context.coordinator, queue: DispatchQueue(label: "videoQueue"))
//        videoOutput.alwaysDiscardsLateVideoFrames = true
//        
//        if captureSession.canAddOutput(videoOutput) {
//            captureSession.addOutput(videoOutput)
//            print("makeUIViewController: VideoOutput 추가됨")
//        } else {
//            print("Unable to add video output to session")
//        }
//        
//        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        videoPreviewLayer.connection?.videoOrientation = .landscapeRight
//        videoPreviewLayer.videoGravity = .resizeAspectFill
//        videoPreviewLayer.frame = viewController.view.bounds
//        viewController.view.layer.addSublayer(videoPreviewLayer)
//        
//        DispatchQueue.global(qos: .userInitiated).async {
//            captureSession.startRunning()
//            print("makeUIViewController: CaptureSession 시작됨")
//        }
//        
//        return viewController
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
//}


//import SwiftUI
//import AVFoundation
//import Vision
//
//struct HandPoseView: UIViewControllerRepresentable {
//    
//    @Binding var rockProbability: Double
//    @Binding var paperProbability: Double
//    @Binding var scissorsProbability: Double
//    
//    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
//        var parent: HandPoseView
//        
//        init(parent: HandPoseView) {
//            self.parent = parent
//        }
//        
//        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//            print("captureOutput 호출됨: 프레임이 수신됨")
//
//            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
//                print("captureOutput: pixelBuffer is nil")
//                return
//            }
//            
//            print("pixelBuffer가 유효합니다")
//            
//            // 포즈 추정을 위한 Vision Request
//            let request = VNDetectHumanBodyPoseRequest { request, error in
//                if let results = request.results as? [VNHumanBodyPoseObservation] {
//                    for observation in results {
//                        // 관절 좌표 추출
//                        let joints = observation.availableJointNames.compactMap { jointName -> (VNRecognizedPointKey, VNRecognizedPoint)? in
//                            guard let point = try? observation.recognizedPoint(jointName) else { return nil }
//                            return (jointName, point) as! (VNRecognizedPointKey, VNRecognizedPoint) // JointName을 직접 사용
//                        }
//                        
//                        let jointsDict = Dictionary(uniqueKeysWithValues: joints)
//                        
//                        // 추출된 관절 좌표를 PoseClassifier로 전달하여 동작 분류
//                        PoseClassifierModel.shared.classifyPose(joints: jointsDict) { probabilities in
//                            DispatchQueue.main.async {
//                                print("확률 계산 완료: \(probabilities)")
//                                self.parent.rockProbability = probabilities["rock"] ?? 0.0
//                                self.parent.paperProbability = probabilities["paper"] ?? 0.0
//                                self.parent.scissorsProbability = probabilities["scissors"] ?? 0.0
//                            }
//                        }
//                    }
//                }
//            }
//
//            // Vision 요청 핸들러
//            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
//            do {
//                try handler.perform([request])
//            } catch {
//                print("포즈 요청 처리 실패: \(error)")
//            }
//        }
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(parent: self)
//    }
//    
//    func makeUIViewController(context: Context) -> UIViewController {
//        let viewController = UIViewController()
//        print("makeUIViewController: ViewController 생성됨")
//        
//        let captureSession = AVCaptureSession()
//        captureSession.sessionPreset = .high
//        print("makeUIViewController: CaptureSession 생성됨")
//        
//        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
//            print("No front camera available")
//            return viewController
//        }
//        
//        do {
//            let input = try AVCaptureDeviceInput(device: captureDevice)
//            captureSession.addInput(input)
//            print("makeUIViewController: Input 추가됨")
//        } catch {
//            print("Error setting device input: \(error)")
//            return viewController
//        }
//        
//        let videoOutput = AVCaptureVideoDataOutput()
//        videoOutput.setSampleBufferDelegate(context.coordinator, queue: DispatchQueue(label: "videoQueue"))
//        videoOutput.alwaysDiscardsLateVideoFrames = true
//        
//        if captureSession.canAddOutput(videoOutput) {
//            captureSession.addOutput(videoOutput)
//            print("makeUIViewController: VideoOutput 추가됨")
//        } else {
//            print("Unable to add video output to session")
//        }
//        
//        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        videoPreviewLayer.connection?.videoOrientation = .landscapeRight
//        videoPreviewLayer.videoGravity = .resizeAspectFill
//        videoPreviewLayer.frame = viewController.view.bounds
//        viewController.view.layer.addSublayer(videoPreviewLayer)
//        
//        DispatchQueue.global(qos: .userInitiated).async {
//            captureSession.startRunning()
//            print("makeUIViewController: CaptureSession 시작됨")
//        }
//        
//        return viewController
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
//}
