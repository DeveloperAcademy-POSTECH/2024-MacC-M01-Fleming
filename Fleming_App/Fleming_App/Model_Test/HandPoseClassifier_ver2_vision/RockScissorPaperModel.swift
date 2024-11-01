////
////  RockScissorPaperModel.swift
////  Fleming_App
////
////  Created by Leo Yoon on 10/17/24.
////
//
//import SwiftUI
//
//enum Choice: String, CaseIterable {
//    case rock = "바위"
//    case paper = "보"
//    case scissors = "가위"
//}
//
//class RockScissorPaperModel: ObservableObject {
//    @Published var userChoice: Choice?
//    @Published var opponentChoice: Choice?
//    @Published var winCount: Int = 0
//    @Published var loseCount: Int = 0
//    @Published var drawCount: Int = 0
//
//    // 상대방의 선택을 미리 생성하는 함수
//    func generateOpponentChoice() {
//        opponentChoice = Choice.allCases.randomElement()
//    }
//
//    // 상대방의 선택을 보여주는 텍스트
//    func opponentChoiceText() -> String {
//        guard let opponentChoice = opponentChoice else {
//            return "대기 중..."
//        }
//        return "저는 \(opponentChoice.rawValue)을 낼 것입니다."
//    }
//
//    // 사용자가 선택에 따라 승리, 패배, 비김을 결정
//    func playGame(with userChoice: Choice) {
//        self.userChoice = userChoice
//        guard let opponentChoice = opponentChoice else { return }
//        
//        switch (userChoice, opponentChoice) {
//        case (.rock, .scissors), (.scissors, .paper), (.paper, .rock):
//            winCount += 1
//        case (.scissors, .rock), (.paper, .scissors), (.rock, .paper):
//            loseCount += 1
//        default:
//            drawCount += 1
//        }
//    }
//
//    // 결과에 따른 텍스트 반환
//    func resultText() -> String {
//        guard let userChoice = userChoice, let opponentChoice = opponentChoice else {
//            return "결과를 확인할 수 없습니다."
//        }
//        
//        if userChoice == opponentChoice {
//            return "비겼습니다!"
//        } else if (userChoice == .rock && opponentChoice == .scissors) ||
//                    (userChoice == .scissors && opponentChoice == .paper) ||
//                    (userChoice == .paper && opponentChoice == .rock) {
//            return "이겼습니다!"
//        } else {
//            return "졌습니다!"
//        }
//    }
//
//    // 선택만 초기화 (전적은 유지)
//    func resetChoices() {
//        userChoice = nil
//        generateOpponentChoice() // 상대방의 선택은 미리 생성
//    }
//
//    // 게임 전적 리셋
//    func resetGame() {
//        winCount = 0
//        loseCount = 0
//        drawCount = 0
//        resetChoices()
//    }
//}
