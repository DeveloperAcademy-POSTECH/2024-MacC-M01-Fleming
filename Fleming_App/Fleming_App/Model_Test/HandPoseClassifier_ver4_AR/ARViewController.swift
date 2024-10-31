//
//  ARViewController.swift
//  CameraTest
//
//  Created by Leo Yoon on 10/28/24.
//
// SPDX-License-Identifier: MIT
// 원문출처: https://github.com/mdo91/HandPoseML


import Foundation
import ARKit
import SwiftUI

// ARKit을 통해 손모양을 인식, 분류, 표시하는 UIViewController
class ARViewController: UIViewController, ARSessionDelegate {
    
    // 변수설정
    var arView: ARSCNView! // ARKit의 ARSCNView를 사용하여, AR 콘텐츠를 표시함

    @Binding var labelText: String
    @Binding var secondLabelText: String
    @Binding var confidenceValue: Int
    
    // 손포즈 인식용 frameCounter 및 예측 간격
    private var frameCounter = 0
    private let handPosePredictionInterval = 30
    
    init(labelText: Binding<String>, secondLabelText: Binding<String>, confidenceValue: Binding<Int>) {
            _labelText = labelText
            _secondLabelText = secondLabelText
            _confidenceValue = confidenceValue
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    
    // 초기 설정(카메라 권한 확인 <- 호출)
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCameraAccess()
    }
    
    // 카메라 권한 확인
    func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            
            // ARKit 세션을 초기화
            setupARView()
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { enabled in
                DispatchQueue.main.async {
                    enabled ? self.setupARView() : print("카메라 접근 권한이 없습니다.")
                    if enabled {
                        self.setupARView()
                    } else {
                        print("카메라 접근 권한이 없습니다.")
                    }
                }
            }
        case .denied, .restricted:
            print("카메라 접근이 거부되었습니다.")
            
        @unknown default:
            print("Error")
        }
    }
    
    // ARKit세션 구성 및 arView와 stackView를 설정
    func setupARView() {
        arView = ARSCNView(frame: view.bounds)
        arView.session.delegate = self
        view.addSubview(arView)
        
        // generak world tracking
        let configuration = ARWorldTrackingConfiguration()
        
        // enable the front camera
        if ARFaceTrackingConfiguration.isSupported {
            let faceTrackingConfig = ARFaceTrackingConfiguration()
            arView.session.run(faceTrackingConfig)
        } else {                                // not supported
            arView.session.run(configuration)   // show an alert
        }
        
    }
    
    // MARK: - delegate funcs
    
    // ARKit 세션의 업데이트 메서드, 각 프레임마다 손모양 감지. 모델을 사용해 포즈 예측.
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        frameCounter += 1
        let pixelBuffer = frame.capturedImage
        
        // 손 인식 조건 세팅
        let handPoseRequest = VNDetectHumanHandPoseRequest()        //
        handPoseRequest.maximumHandCount = 1                        // 손을 한 개만 인식함.
        handPoseRequest.revision = VNDetectContourRequestRevision1  //
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        
        do {
            try handler.perform([handPoseRequest])
        } catch {
            assertionFailure("Human Pose Request failed: \(error.localizedDescription)")
        }
        
        guard let handPoses = handPoseRequest.results, !handPoses.isEmpty else { return }
        let handObservations = handPoses.first
    
        if frameCounter % handPosePredictionInterval == 0 {
            
            // 손을 ML 모델에 매칭
            guard let keypointsMultiArray = try? handObservations!.keypointsMultiArray() else {
                fatalError("Failed to create key points array")
            }
            do {
                let config = MLModelConfiguration()
                config.computeUnits = .cpuAndGPU
                
                // ML모델 셋업(.mlmodel과 연결)
                let model = try HandPoseClassifier_241024.init(configuration: config)
                
                let handPosePrediction = try model.prediction(poses: keypointsMultiArray)
                let confidence = handPosePrediction.labelProbabilities[handPosePrediction.label]!
                DispatchQueue.main.async { [weak self] in
                    self?.labelText = handPosePrediction.label // 예시 데이터
                    self?.secondLabelText = handPosePrediction.label  // "상태 업데이트"
                    self?.confidenceValue = Int(confidence * 100)
                    
                    
                }
                print("labelProbabilities \(handPosePrediction.labelProbabilities)")

                // 핸드포즈 정확도율 기준(0.9가 기본값이었음.)
                if confidence > 0.8 {

                    print("handPosePrediction: \(handPosePrediction.label)")
                    renderHandPose(name: handPosePrediction.label)
                } else {
                    print("handPosePrediction: \(handPosePrediction.label)")
//                    cleanEmojii()
                }
                
            } catch let error {
                print("Failure HandyModel: \(error.localizedDescription)")
            }
            
        }
    }
    
    // MARK: - private funcs
    
    // (labelText) 손모양 감지하면, 이름 및 텍스트를 print.
    private func renderHandPose(name: String) {
        switch name {
        case "rock":
            print("Rock handPose dedicted...")
            
        case "paper":
            print("Paper handpose dedicted")
            
        case "scissors":
            print("Scissors handpose dedicted")
            
            
        default:
            print("Remove nodes")
//            cleanEmojii()
        }
    }
    
}
