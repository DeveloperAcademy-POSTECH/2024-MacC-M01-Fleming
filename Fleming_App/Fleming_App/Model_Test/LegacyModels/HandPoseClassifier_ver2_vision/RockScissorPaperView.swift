////
////  RockScissorPaperView.swift
////  Fleming_App
////
////  Created by Leo Yoon on 10/17/24.
////
//
//import SwiftUI
//
//struct RockScissorPaperView: View {
//    @ObservedObject var viewModel = RockScissorPaperModel()
//    @State private var gameEnded = false
//    
//    var body: some View {
//        VStack {
//            Text("가위바위보 게임")
//                .font(.largeTitle)
//                .padding()
//            
//            HStack {
//                // 상대방의 선택 (왼쪽)
//                VStack {
//                    Text("상대방의 선택")
//                        .font(.headline)
//                    Rectangle()
//                        .fill(Color.gray.opacity(0.3))
//                        .frame(width: 150, height: 150)
//                        .overlay(
//                            Text(viewModel.opponentChoiceText())
//                                .font(.title)
//                                .multilineTextAlignment(.center)
//                        )
//                }
//                
//                Spacer()
//                
//                // 사용자의 선택 (오른쪽)
//                if !gameEnded {
//                    VStack {
//                        Text("내 선택")
//                            .font(.headline)
//                        HStack {
//                            ForEach(Choice.allCases, id: \.self) { choice in
//                                Button(action: {
//                                    viewModel.playGame(with: choice) // 이제 승리/패배/비김 결정
//                                    gameEnded = true // 게임이 끝났다고 표시
//                                }) {
//                                    Text(choice.rawValue)
//                                        .padding()
//                                        .background(Color.blue)
//                                        .foregroundColor(.white)
//                                        .cornerRadius(8)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            .padding()
//            
//            // 결과 표시
//            if let userChoice = viewModel.userChoice, let opponentChoice = viewModel.opponentChoice {
//                Text("결과: \(viewModel.resultText())")
//                    .font(.title)
//                    .padding()
//            }
//            
//            VStack {
//                Text("승리: \(viewModel.winCount)회")
//                Text("패배: \(viewModel.loseCount)회")
//                Text("비김: \(viewModel.drawCount)회")
//            }
//            .padding()
//            
//            // "한 번 더" 버튼
//            if gameEnded {
//                Button(action: {
//                    viewModel.resetChoices()
//                    gameEnded = false // 게임이 다시 시작될 수 있게 상태를 리셋
//                }) {
//                    Text("한 번 더")
//                        .padding()
//                        .background(Color.green)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//                .padding()
//            }
//            
//            // 리셋 버튼
//            Button(action: {
//                viewModel.resetGame()
//                gameEnded = false
//            }) {
//                Text("게임 전적 리셋")
//                    .padding()
//                    .background(Color.red)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//            }
//            .padding()
//        }
//        .padding()
//        .onAppear {
//            viewModel.generateOpponentChoice() // 뷰가 나타날 때 상대방의 선택 미리 생성
//        }
//    }
//}
//
//#Preview {
//    RockScissorPaperView()
//}
