//
//  Untitled.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/23/24.
//

//import CoreML
//import Vision
//
//class PoseClassifierModel {
//    
//    static let shared = PoseClassifierModel()
//
//    // RockPaperScissors 모델 로드 (입력 타입에 맞춰 조정)
//    private let model: RockPaperScissors = {
//        do {
//            let config = MLModelConfiguration()
//            return try RockPaperScissors(configuration: config)
//        } catch {
//            fatalError("Failed to load RockPaperScissors model: \(error)")
//        }
//    }()
//    
//    // 관절 좌표를 받아서 포즈 분류
//    func classifyPose(joints: [VNRecognizedPointKey: VNRecognizedPoint]) -> String {
//        // 관절 좌표를 모델의 입력 형식에 맞게 변환
//        let jointValues = joints.map { $0.value.location }
//
//        // 모델이 요구하는 입력 형식으로 변환하여 전달
//        guard let inputArray = createMLMultiArray(from: jointValues) else {
//            return "Invalid Input"
//        }
//
//        // 모델 예측 실행 - 'poses'로 수정
//        guard let input = try? RockPaperScissorsInput(poses: inputArray),
//              let poseOutput = try? model.prediction(input: input) else {
//            return "Unknown"
//        }
//
//        // 예측된 결과 반환 (예: "Rock", "Paper", "Scissors")
//        return poseOutput.label
//    }
//    
//    // CGPoint 배열을 MLMultiArray로 변환하는 함수
//    private func createMLMultiArray(from points: [CGPoint]) -> MLMultiArray? {
//        let count = points.count * 2 // x와 y 좌표를 위해 * 2
//        guard let multiArray = try? MLMultiArray(shape: [NSNumber(value: count)], dataType: .float32) else {
//            return nil
//        }
//
//        for (index, point) in points.enumerated() {
//            multiArray[index * 2] = NSNumber(value: Float(point.x))
//            multiArray[index * 2 + 1] = NSNumber(value: Float(point.y))
//        }
//
//        return multiArray
//    }
//}


//import CoreML
//import Vision
//
//class PoseClassifierModel {
//    
//    static let shared = PoseClassifierModel()
//
//    // RockPaperScissors 모델 로드
//    private let model: RockPaperScissors = {
//        do {
//            let config = MLModelConfiguration()
//            return try RockPaperScissors(configuration: config)
//        } catch {
//            fatalError("Failed to load RockPaperScissors model: \(error)")
//        }
//    }()
//    
//    // 관절 좌표를 받아서 포즈 분류
//    func classifyPose(joints: [VNRecognizedPointKey: VNRecognizedPoint], completion: @escaping ([String: Double]) -> Void) {
//        // 관절 좌표를 모델의 입력 형식에 맞게 변환
//        let jointValues = joints.map { $0.value.location }
//
//        // 모델이 요구하는 입력 형식으로 변환하여 전달
//        guard let inputArray = createMLMultiArray(from: jointValues) else {
//            completion(["rock": 0.0, "paper": 0.0, "scissors": 0.0])
//            return
//        }
//
//        // 모델 예측 실행
//        guard let input = try? RockPaperScissorsInput(poses: inputArray),
//              let poseOutput = try? model.prediction(input: input) else {
//            completion(["rock": 0.0, "paper": 0.0, "scissors": 0.0])
//            return
//        }
//
//        // labelProbabilities로 각 클래스의 확률 가져오기
//        let probabilities = poseOutput.labelProbabilities
//        let rockProbability = probabilities["rock"] ?? 0.0
//        let paperProbability = probabilities["paper"] ?? 0.0
//        let scissorsProbability = probabilities["scissors"] ?? 0.0
//
//        // 예측 결과를 반환 (클래스 이름과 확률)
//        completion(["rock": rockProbability, "paper": paperProbability, "scissors": scissorsProbability])
//    }
//    
//    // CGPoint 배열을 MLMultiArray로 변환하는 함수
//    private func createMLMultiArray(from points: [CGPoint]) -> MLMultiArray? {
//        let count = points.count * 2 // x와 y 좌표를 위해 * 2
//        guard let multiArray = try? MLMultiArray(shape: [NSNumber(value: count)], dataType: .float32) else {
//            print("MLMultiArray 생성 실패")
//            return nil
//        }
//
//        for (index, point) in points.enumerated() {
//            multiArray[index * 2] = NSNumber(value: Float(point.x))
//            multiArray[index * 2 + 1] = NSNumber(value: Float(point.y))
//        }
//
//        print("MLMultiArray 생성 성공: \(multiArray)")
//        return multiArray
//    }
//}
