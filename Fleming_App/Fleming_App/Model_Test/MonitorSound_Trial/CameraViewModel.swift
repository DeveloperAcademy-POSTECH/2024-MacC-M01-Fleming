////
////  CameraViewModel.swift
////  BoBuSang_Trial
////
////  Created by Leo Yoon on 10/7/24.
////
//
//import AVFoundation
//import SwiftUI
//
//class CameraViewModel: ObservableObject {
//    @Published var isUsingFrontCamera: Bool = true
//    var captureSession: AVCaptureSession? // 접근 제한자 제거
//    
//    private var currentInput: AVCaptureDeviceInput?
//    
//    func setupCamera() {
//        captureSession = AVCaptureSession()
//        guard let captureSession = captureSession else { return }
//        captureSession.sessionPreset = .photo
//        
//        captureSession.sessionPreset = .hd1280x720 // 또는 .hd1920x1080
//        switchCamera()
//    }
//    
//    func switchCamera() {
//        guard let captureSession = captureSession else { return }
//        
//        captureSession.beginConfiguration()
//        
//        if let currentInput = currentInput {
//            captureSession.removeInput(currentInput)
//        }
//        
//        // 카메라 전환 로직
//        guard let newCamera = isUsingFrontCamera ? getFrontCamera() : getBackCamera() else {
//            print("카메라를 찾을 수 없습니다.")
//            return
//        }
//        
//        do {
//            let input = try AVCaptureDeviceInput(device: newCamera)
//            if captureSession.canAddInput(input) {
//                captureSession.addInput(input)
//                currentInput = input
//            }
//        } catch {
//            print("Error switching cameras: \(error)")
//        }
//        
//        captureSession.commitConfiguration()
//        captureSession.startRunning()
//    }
//    
//    func getFrontCamera() -> AVCaptureDevice? {
//        return AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
//    }
//    
//    func getBackCamera() -> AVCaptureDevice? {
//        return AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
//    }
//    
//    func stopSession() {
//        captureSession?.stopRunning()
//    }
//}
