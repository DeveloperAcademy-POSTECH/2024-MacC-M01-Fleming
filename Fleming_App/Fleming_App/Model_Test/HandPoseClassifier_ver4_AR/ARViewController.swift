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

// ARKit을 통해 손모양을 인식, 분류, 표시하는 UIViewController
class ARViewController: UIViewController, ARSessionDelegate {
    
    // vars
    var arView: ARSCNView! // ARKit의 ARSCNView를 사용하여, AR 콘텐츠를 표시함
    var labelText: String = "" { // 손모양에 따라 secondLabel 텍스트를 업데이트 함.
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.secondLabel.text = self.labelText
            }
            
        }
    }
    
    // 손모양, 손정보 등을 표시하는 UILabel
    private var label: UILabel = UILabel()
    private var secondLabel = UILabel()
    private var thirdLabel = UILabel()
    
    // secondLabel, thirdLabel등 화면에 배치하기 위한 UIStackView.
    private var stackView: UIStackView = UIStackView()
    
    // 손포즈 인식용 frameCounter 및 예측 간격
    private var frameCounter = 0
    private let handPosePredictionInterval = 30
    
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
                    if enabled {
                        self.setupARView()
                    } else {
                        print("not working...")
                    }
                }
            }
        case .denied, .restricted:
            print("Check settings..")
            
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
        } else {
            // not supported
            // show an alert
            arView.session.run(configuration)
        }
        
        // add the label on the top or AR view
        // confidence
        thirdLabel = UILabel(frame: .init(x: 0, y: 0, width: 300, height: 12))
        thirdLabel.text = ""
        thirdLabel.textColor = .black
        thirdLabel.font = .systemFont(ofSize: 26)
        thirdLabel.backgroundColor = .lightText
        thirdLabel.textAlignment  = .center
        
        label = UILabel(frame: .init(x: 0, y: 0, width: self.view.frame.width, height: 30))
        label.text = labelText
        label.textColor = .white
        label.font = .systemFont(ofSize: 65)
        
        secondLabel = UILabel(frame: .init(x: 0, y: 0, width: self.view.frame.width, height: 12))
        secondLabel.text = labelText
        secondLabel.textColor = .white
        secondLabel.font = .systemFont(ofSize: 65)
        secondLabel.backgroundColor = .lightText
        secondLabel.textAlignment = .center
        
        // stack view
        stackView = .init(frame: .init(x: 0, y: 40, width: (self.view.frame.width), height: 200))
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.addArrangedSubview(secondLabel)
        stackView.addArrangedSubview(thirdLabel)
        stackView.spacing = 2
        stackView.layoutMargins = .init(top: 10, left: 30, bottom: 10, right: 30)
        
        
        view.addSubview(stackView)
        
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
        
        guard let handPoses = handPoseRequest.results, !handPoses.isEmpty else {
            // no effects to draw
            return
        }
        
        let handObservations = handPoses.first
        
        
        if frameCounter % handPosePredictionInterval == 0 {
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
                    guard let self = self else { return }
                    self.thirdLabel.text = "\(self.convertToPercentage(confidence))%"
                }
                print("labelProbabilities \(handPosePrediction.labelProbabilities)")

                // render handpose effect
                if confidence > 0.9 {

                    print("handPosePrediction: \(handPosePrediction.label)")
                    renderHandPose(name: handPosePrediction.label)
                } else {
                    print("handPosePrediction: \(handPosePrediction.label)")
                    cleanEmojii()

                }
                
            } catch let error {
                print("Failure HandyModel: \(error.localizedDescription)")
            }
            
            
        }
    }
    
    // MARK: - private funcs
    
    // (labelText) 손모양 감지하면, 이름 및 텍스트를 표시하는 메서드(기본탑재)
    private func renderHandPose(name: String) {
        switch name {
        case "rock":
            
            self.showEmoji(for: .rock)
            print("Rock handPose dedicted...")
            
        case "paper":
            
            self.showEmoji(for: .paper)
            print("Paper handpose dedicted")
            
        case "scissors":
            self.showEmoji(for: .scissors)
            print("Scissors handpose dedicted")
            
            
        default:
            print("Remove nodes")
            cleanEmojii()
        }
    }
    
    // (labelText) 손모양 감지하면, 해당하는 이모지를 반환하는 메서드 <- 기본탑재
    private func showEmoji(for pose: Pose) {
        
        switch pose {
        case .rock:
            DispatchQueue.main.async { [weak self]  in
                guard let self = self else { return }
             //   self.secondLabel.text = "👊"
                self.labelText = "👊"
            }
        case .paper:
            
            DispatchQueue.main.async { [weak self]  in
                guard let self = self else { return }
                
                self.labelText = "✋"
            }
        case .scissors:
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.labelText = "✌️"
            }
        }
    }
    
    // (labelText, secondLabel) 감지된 모양이 없을 시, 라벨값을 초기화함
    private func cleanEmojii() {
        
        DispatchQueue.main.async {
            self.labelText = ""
            self.secondLabel.text = ""
        }
    }
    
    // (ThirdLabel) 모델의 신뢰도를 나타내는 유틸리티 메서드
    private func convertToPercentage(_ value: Double) -> Float {
        let result = Int((value * 1000))
        
        return Float(result) / 10
    }
    
    enum Pose: String {
        case rock = "Rock"
        case paper = "Paper"
        case scissors = "Scissors"
        
    }
    
    
}
