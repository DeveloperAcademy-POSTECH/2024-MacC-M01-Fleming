//
//  RockPapeerScissors2.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/18/24.
//

import SwiftUI

struct RockPaperScissors2: View {
    @State private var winnerCount = 0 // 반복횟수 카운팅용
    @Binding var currentStep: Int // 현재 페이지
    
    //for random by hera
    //@State private var currentImage_random : String = ""
    //var currentImage_random:  Binding<String>
    @Binding var currentImage_random: String // Binding으로 변경
    
    let images = ["object_RockPaperScissors_Paper", "object_RockPaperScissors_Scissors", "object_RockPaperScissors_Rock"]
    //
    //    init() {
    //        _currentImage = State(initialValue: "object_RockPaperScissors_Rock")
    //    }
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    // 반복연습과 관련있는 변수들
    @State var repeatCount = 0 // 몇 회 반복?
    @Binding var repeatNumber : Int
    @State private var refresh = false
    let refreshTime: TimeInterval = 2.0
    
    var body: some View {
        
        ZStack{
            Image("Background_RPSView")
                .resizable()
                .scaledToFill()
                .frame(width: screenWidth, height: screenHeight, alignment: .center)
                .offset(x:0, y:0)
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                
                Text("Rock Paper Scissors !")
                    .font(.system(size: 80, weight: .bold))
                    .foregroundStyle(.blue)
                    .padding(.bottom, screenHeight * 0.05)
                
                HStack(){
                    Spacer()
                    
                    // 상대방 미리낼 것 (잠시 주석처리)
                    VStack{
                        Text("Friend")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundStyle(.blue)
                        
                        ZStack{
                            Rectangle()
                                .foregroundStyle(Color(AppColor.handBackgroundColor))
                                .frame(width:screenHeight * 0.6, height: screenHeight * 0.6)
                                .clipShape(ButtonBorderShape.roundedRectangle(radius: 50))
                            
                            Image(currentImage_random)
                                .frame(width: screenHeight * 0.55)
                        }
                    }
                    Spacer()
                    
                    // 내가 낼 것
                    VStack{
                        Text("Me")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundStyle(.blue)
                        
                        ZStack{
                            Rectangle()
                                .foregroundStyle(Color(AppColor.handBackgroundColor))
                                .frame(width:screenHeight * 0.6, height: screenHeight * 0.6)
                                .clipShape(ButtonBorderShape.roundedRectangle(radius: 50))
                            //if repeatCount < repeatNumber{
                            RockPaperScissors_cam(currentImage_random: $currentImage_random, images:images, repeatNumber: $repeatNumber)
                            // 현재는 신모델[ARKit], 구모델은 [Vision]활용한 RSP_CameraView(model: model)
                            //                                    .background(Color.brown) // ChildView의 영역 확인용.
                            //                                    .frame(width:screenHeight * 0.55, height: screenHeight * 0.55, alignment: .center) // 바로 카메라 왼쪽 위가 잘리는 현상 발생 (그 외에 frame은 정상범주) // .topLeading .center .bottomTrailing 모두 안됌. - edges Ignoring 하기 전
                            //                                    .frame(width:screenHeight * 0.55, height: screenHeight * 0.55, alignment: .center) // 잘림없이 밀리는 현상 발생 (edge ignoring 걸어두었을 때)
                                .frame(width:screenHeight * 0.55, height: screenHeight * 0.55, alignment: .topLeading) // 영역은 정확함. RockPaperScissors_cam 내부에서 확인해봅시다.
                        }
                    }
                    Spacer()
                    
                } // HStack 끝
            }
            
            //            Button(action: {
            //                winnerCount += 1
            //                if winnerCount >= 3{
            //                    currentStep = 3
            //                    currentImage_random = images.randomElement() ?? "object_RockPaperScissors_Rock"
            //                }
            //            }, label: {
            //                Image(systemName: "speaker.wave.2.fill")
            //                    .font(.system(size:40))
            //                    .bold()
            //                    .foregroundStyle(.orange)
            //            })
            //            .offset(x: screenWidth/2 - 60, y: -screenHeight/2 + 60)
            
        }
        .onAppear(){
            currentImage_random = images.randomElement() ?? "object_RockPaperScissors_Paper"
        }
    }
    
}

//by hera
func determinewin (player : String, computer: String) -> String {
    switch (player, computer) {
    case ("rock", "object_RockPaperScissors_Scissors"), ("scissors", "object_RockPaperScissors_Paper"), ("paper", "object_RockPaperScissors_Rock"):
        return "Win"
    case ("scissors", "object_RockPaperScissors_Rock"), ("paper", "object_RockPaperScissors_Scissors"), ("rock", "object_RockPaperScissors_Paper"):
        return "Try Again"
    case ("scissors", "object_RockPaperScissors_Scissors"), ("paper", "object_RockPaperScissors_Paper"), ("rock", "object_RockPaperScissors_Rock"):
        return "Same"
    default:
        return "nil"
    }
    
}




struct RockPaperScissors_cam: View {
    @State private var labelText: String = "손 모양을 인식 중..."
    @State private var secondLabelText: String = "손 모양 상태"
    @State private var confidenceValue: Int = 0
    //for popup //by hera
    //    @State private var result: String = ""
    //    @Binding var result: String
    @Binding var currentImage_random: String
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    let images: [String]
    
    @State private var showFullScreenView = false
    
    
    @State private var resultText: String = ""
    @State var repeatCount = 0 // 몇 회 반복?
    @Binding var repeatNumber : Int
    
    var result: String {
        determinewin(player: labelText, computer: currentImage_random)
    }
    
    private func countUpdate() {
        repeatCount += 1
    }
    //
    //    let images = ["object_RockPaperScissors_Paper", "object_RockPaperScissors_Scissors", "object_RockPaperScissors_Rock"] // 추가
    
    
    var body: some View {
        
        ZStack{
            ARViewContainer(labelText: $labelText, secondLabelText: $secondLabelText, confidenceValue: $confidenceValue) // 신형 (ARKit)
                .scaleEffect(0.55, anchor: .bottomTrailing)
                .offset(x: -screenWidth * 0.5 * 0.5, y: -screenHeight * 0.5 * 0.5) // (x,y) = (0,0)일 때, 밀려서 시도중... / 너무 많이 밀린다...
                .edgesIgnoringSafeArea(.all)
                .clipShape(RoundedRectangle(cornerRadius: 80))
            VStack {
                if repeatCount < repeatNumber {
                    if confidenceValue > 80 {
                        //                    Text("예측 결과: \(labelText)")
                        Text(resultText)
                        // 결과 텍스트를 표시
                            .font(.system(size: 100, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .shadow(color: .yellow, radius: 10)
                            .padding(.bottom, 50)
                        //let gameresult = determinewin(player: labelText, computer: currentImage_random)
                        
                        //if gameresult != result {
                        //result = gameresult
                        //} for update by hera
                        
                        
                        //                    Text("게임 결과 \(result)")
                        
                        //processGameResult()
                    } else {
                        Text("Please choose between rock, paper, scissors.")
                            .foregroundColor(.black)
                            .padding(.bottom, 50)
                    }
                    
                }
                else {
                    //                    RockPaperScissors3()
                    //                        .transition(.asymmetric(
                    //                        insertion: .move(edge: .trailing), // 새 뷰는 오른쪽에서 등장
                    //                        removal: .opacity))
                    Text("You did a GOOD JOB!")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.red)
                        .padding(.bottom, 50)
                    //showFullScreenView = true
                    
                }
            }
        }.onChange(of: confidenceValue) { newValue in
            if newValue > 80 && repeatCount < repeatNumber  {
                processGameResult()
            }
        }
        .sheet(isPresented: $showFullScreenView) {
            RockPaperScissors3() // Present full-screen view
        }
        .onAppear {
            if repeatCount >= repeatNumber {
                showFullScreenView = true // 게임이 끝나면 전체 화면 전환
            }
        }
    }
    
    // for notice by hera
    //                        if result == "Win" {
    //                            let _ = countUpdate()
    //                            ZStack{
    //                                Text("WIN!")
    //                                    .font(.system(size: 100, weight: .bold, design: .rounded))
    //                                    .foregroundColor(.black)
    //                                    .shadow(color: .yellow, radius: 10, x: 0, y: 0)
    //                                    .padding(.bottom, screenHeight / 3)
    //                                    currentImage_random = images.randomElement() ?? "object_RockPaperScissors_Rock"
    //
    //                            }
    //                        }
    //                        else if result == "Try Again"{
    //                            let _ = countUpdate()
    //                            Text("Try Again!")
    //                                .font(.system(size: 100, weight: .bold, design: .rounded))
    //                                .foregroundColor(.black)
    //                                .shadow(color: .yellow, radius: 10, x: 0, y: 0)
    //                                .padding(.bottom, screenHeight / 3)
    //                        }
    //                        else if result == "Same" {
    //                            let _ = countUpdate()
    //                            Text("It's tied!")
    //                                .font(.system(size: 100, weight: .bold, design: .rounded))
    //                                .foregroundColor(.black)
    //                                .shadow(color: .yellow, radius: 10, x: 0, y: 0)
    //                                .padding(.bottom, screenHeight / 3)
    //                        }
    //                    } else {
    //                        Text("Please choose between rock, paper, scissors.")
    //                    }
    //                // 결과 텍스트를 표시
    //                Text(resultText)
    //                    .font(.system(size: 100, weight: .bold, design: .rounded))
    //                    .foregroundColor(.black)
    //                    .shadow(color: .yellow, radius: 10)
    //                    .padding(.bottom, 50)
    
    // .background(Color.green) // 화면크기는 ParentView와 동일한 것을 확인 함.
    
    
    func processGameResult() {
        let gameResult = result
        
        if gameResult == "Win" {
            repeatCount += 1
            currentImage_random = images.randomElement() ?? "object_RockPaperScissors_Rock"
            //showResultText("WIN!")
            resultText = "WIN!"
            
        } else if gameResult == "Try Again" {
            //repeatCount += 1
            //showResultText("Try Again!")
            resultText = "Try Again!"
            
        } else if gameResult == "Same" {
            //repeatCount += 1
            //showResultText("It's tied!")
            resultText = "It's tied!"
            
        }
        if repeatCount >= repeatNumber {
            showFullScreenView = true
        }
    }
    
    private func showResultText(_ text: String) {
        Text(text)
            .font(.system(size: 100, weight: .bold, design: .rounded))
            .foregroundColor(.black)
            .shadow(color: .yellow, radius: 10)
            .padding(.bottom, 50)
            .animation(.default)
    }
}
