////
////  RockScissorsPaperMLModel.swift
////  Fleming_App
////
////  Created by Leo Yoon on 10/18/24.
////
//
//// (Option.2) 카메라 조작 후
//
//import AVFoundation
//import Vision
//import CoreML
//import SwiftUI
////
//class RockScissorsPaperMLModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
//    @Published var predictionLabel: String = "대기 중..."
//    
//    private var captureSession: AVCaptureSession?
//    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
//    
//    // 신뢰도 임계값 (0.7 이상일 때만 결과 반영)
//    private let confidenceThreshold: Float = 0.7
//    
//    // 인식할 영역의 비율 (예: 화면의 가운데 부분만 처리)
//    private let regionOfInterest = CGRect(x: 0.25, y: 0.25, width: 0.5, height: 0.5) // 화면 가운데 50% 영역
//
//    // Vision Request for Core ML model
//    lazy var visionRequest: VNCoreMLRequest = {
//        do {
//            let model = try VNCoreMLModel(for: RockPaperScissors().model) // Your ML model name
//            let request = VNCoreMLRequest(model: model) { request, error in
//                self.handleVisionRequest(request: request, error: error)
//            }
//
//            // 이미지 처리 옵션
//            request.imageCropAndScaleOption = .centerCrop
//
//            // 여기에서 regionOfInterest 설정 (0 ~ 1 비율)
//            request.regionOfInterest = regionOfInterest
//
//            return request
//        } catch {
//            fatalError("Failed to load Vision ML model: \(error)")
//        }
//    }()
//    
//    // Setup camera session
//    func setupCamera(for view: UIView) {
//        captureSession = AVCaptureSession()
//        
//        // 전면 카메라 설정
//        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
//              let captureSession = captureSession else {
//            fatalError("No front video camera available")
//        }
//        
//        do {
//            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
//            if captureSession.canAddInput(videoInput) {
//                captureSession.addInput(videoInput)
//            }
//        } catch {
//            fatalError("Error setting up video input: \(error)")
//        }
//        
//        let videoOutput = AVCaptureVideoDataOutput()
//        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
//        
//        if captureSession.canAddOutput(videoOutput) {
//            captureSession.addOutput(videoOutput)
//        }
//        
//        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        videoPreviewLayer?.videoGravity = .resizeAspectFill
//        videoPreviewLayer?.frame = view.bounds
//        
//        // 오리엔테이션 설정: Landscape Right에 맞춤
//        if let connection = videoPreviewLayer?.connection, connection.isVideoRotationAngleSupported(90) {
//            connection.videoRotationAngle = 90 // Landscape Right는 90도 회전
//        }
//        
//        view.layer.addSublayer(videoPreviewLayer!)
//        
//        captureSession.startRunning()
//    }
//    
//    // Handle vision request
//    func handleVisionRequest(request: VNRequest, error: Error?) {
//        guard let results = request.results as? [VNClassificationObservation], let topResult = results.first else {
//            return
//        }
//        
//        // 신뢰도 기준 적용
//        DispatchQueue.main.async {
//            if topResult.confidence >= self.confidenceThreshold {
//                self.predictionLabel = topResult.identifier // 신뢰도가 충분할 때만 예측 결과 반영
//            } else {
//                self.predictionLabel = "대기 중..." // 신뢰도가 낮을 때는 예측하지 않음
//            }
//        }
//    }
//    
//    // Stop camera session
//    func stopCamera() {
//        captureSession?.stopRunning()
//    }
//
//    // AVCaptureVideoDataOutputSampleBufferDelegate
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
//            return
//        }
//        
//        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: [:])
//        
//        do {
//            try handler.perform([visionRequest])
//        } catch {
//            print("Error performing vision request: \(error)")
//        }
//    }
//}
//
//// (Option.1) 카메라 조작 전
//
////import AVFoundation
////import Vision
////import CoreML
////import SwiftUI
////
////class RockScissorsPaperMLModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
////    @Published var predictionLabel: String = "대기 중..."
////    
////    private var captureSession: AVCaptureSession?
////    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
////    
////    // 신뢰도 임계값 (0.7 이상일 때만 결과 반영)
////    private let confidenceThreshold: Float = 0.7
////    
////    // Vision Request for Core ML model
////    lazy var visionRequest: VNCoreMLRequest = {
////        do {
////            let model = try VNCoreMLModel(for: RockPaperScissors().model) // Your ML model name
////            let request = VNCoreMLRequest(model: model) { request, error in
////                self.handleVisionRequest(request: request, error: error)
////            }
////            request.imageCropAndScaleOption = .centerCrop
////            return request
////        } catch {
////            fatalError("Failed to load Vision ML model: \(error)")
////        }
////    }()
////    
////    // Setup camera session
////    func setupCamera(for view: UIView) {
////        captureSession = AVCaptureSession()
////        
////        // 전면 카메라 설정
////        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
////              let captureSession = captureSession else {
////            fatalError("No front video camera available")
////        }
////        
////        do {
////            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
////            if captureSession.canAddInput(videoInput) {
////                captureSession.addInput(videoInput)
////            }
////        } catch {
////            fatalError("Error setting up video input: \(error)")
////        }
////        
////        let videoOutput = AVCaptureVideoDataOutput()
////        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
////        
////        if captureSession.canAddOutput(videoOutput) {
////            captureSession.addOutput(videoOutput)
////        }
////        
////        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
////        videoPreviewLayer?.videoGravity = .resizeAspectFill
////        videoPreviewLayer?.frame = view.bounds
////        
////        // 오리엔테이션 설정: Landscape Right에 맞춤
////        if let connection = videoPreviewLayer?.connection, connection.isVideoOrientationSupported {
////            connection.videoOrientation = .landscapeRight
////        }
////        
////        view.layer.addSublayer(videoPreviewLayer!)
////        
////        captureSession.startRunning()
////    }
////    
////    // Handle vision request
////    func handleVisionRequest(request: VNRequest, error: Error?) {
////        guard let results = request.results as? [VNClassificationObservation], let topResult = results.first else {
////            return
////        }
////        
////        // 신뢰도 기준 적용
////        DispatchQueue.main.async {
////            if topResult.confidence >= self.confidenceThreshold {
////                self.predictionLabel = topResult.identifier // 신뢰도가 충분할 때만 예측 결과 반영
////            } else {
////                self.predictionLabel = "대기 중..." // 신뢰도가 낮을 때는 예측하지 않음
////            }
////        }
////    }
////    
////    // Stop camera session
////    func stopCamera() {
////        captureSession?.stopRunning()
////    }
////
////    // AVCaptureVideoDataOutputSampleBufferDelegate
////    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
////        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
////            return
////        }
////        
////        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
////        do {
////            try handler.perform([visionRequest])
////        } catch {
////            print("Error performing vision request: \(error)")
////        }
////    }
////}
