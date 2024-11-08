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
    
    // 카운트다운 기능을 위한 변수들
    @State private var prepCount: Int? = nil
    @State private var showCurrentImage_random: Bool = false
    
    let images = ["object_RockPaperScissors_Paper3", "object_RockPaperScissors_Scissors3", "object_RockPaperScissors_Rock3"]
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    // 반복연습과 관련있는 변수들
    @State var repeatCount = 0 // 몇 회 반복 진행중??
    @Binding var repeatNumber : Int // 앞서서 선택된, 실제 반복 횟수
    @State private var refresh = false
    let refreshTime: TimeInterval = 2.0
    @State var determinedGameResult: Bool = false // 새 게임을 하는 버튼
    
    var body: some View {
        
        ZStack{
            Rectangle()
                .foregroundStyle(AppColor.handColor)
                .frame(width: screenWidth, height: screenHeight, alignment: .center)
                .offset(x:0, y:0)
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                
                Text("Let's win this game!")
                    .font(.system(size: 80, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.bottom, screenHeight * 0.05)
                
                HStack(){
                    Spacer()
                    
                    // 상대방이 낼 것
                    VStack{
                        //                        Text("Friend")
                        //                            .font(.system(size: 40, weight: .bold))
                        //                            .foregroundStyle(.blue)
                        
                        ZStack{
                            Rectangle()
                                .foregroundStyle(.white)
                                .frame(width:screenHeight * 0.6, height: screenHeight * 0.6)
                                .clipShape(ButtonBorderShape.roundedRectangle(radius: 50))
                            
                            Rectangle()
                                .foregroundStyle(Color(AppColor.handColor2))
                                .frame(width:screenHeight * 0.55, height: screenHeight * 0.55)
                                .clipShape(ButtonBorderShape.roundedRectangle(radius: 50))
                            
                            if let index = prepCount {
                                switch index{
                                case 0:
                                    Image("object_RockPaperScissors_number3")
                                        .transition(.opacity)
                                case 1:
                                    Image("object_RockPaperScissors_number2")
                                        .transition(.opacity)
                                case 2:
                                    Image("object_RockPaperScissors_number1")
                                        .transition(.opacity)
                                default:
                                    EmptyView()
                                }
                            }
                            
                            // 3,2,1 끝난 이후 결과표시
                            if showCurrentImage_random{
                                Image(currentImage_random)
                                    .frame(width: screenHeight * 0.55)
//                                    .onAppear{
//                                        currentImage_random = images.randomElement() ?? "object_RockPaperScissors_Paper"
//                                    }
                                // 디버깅용
                                    .onAppear{
                                        printCurrentTime()
                                        print("랜덤이미지 칸이 뜸.")
                                        
                                        currentImage_random = images.randomElement() ?? "object_RockPaperScissors_Paper"
                                        // 디버깅용
                                        printCurrentTime()
                                        print("새 랜덤이미지 선정")
                                    }
                            }
                        }
                        // 카운트다운 진행하기
                        .onAppear{
                            startCountdown()
                        }
                    }
                    Spacer()
                    
                    // 내가 낼 것
                    VStack{
                        //                        Text("Me")
                        //                            .font(.system(size: 40, weight: .bold))
                        //                            .foregroundStyle(.blue)
                        
                        ZStack{
                            Rectangle()
                                .foregroundStyle(Color(AppColor.handColor2))
                                .frame(width:screenHeight * 0.6, height: screenHeight * 0.6)
                                .clipShape(ButtonBorderShape.roundedRectangle(radius: 50))
                            //if repeatCount < repeatNumber{
                            RockPaperScissors_cam(currentImage_random: $currentImage_random, images:images, showCurrentImage_random: $showCurrentImage_random, repeatNumber: $repeatNumber, determinedGameResult: $determinedGameResult)
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
            
        }
        // [구형, 321 적용 전] 화면 뜨자마자 승패 가리는 구조
        //        .onAppear {
        //            currentImage_random = images.randomElement() ?? "object_RockPaperScissors_Paper"
        //        }
        
        
        // 밑에꺼 테스트... (3시 10분)
//        // [신형, 321 적용 후] 화면 뜨고, 가위바위보를 보여주고 싶을 때, 작동하게 함.
//        .onChange(of: showCurrentImage_random){
//                if showCurrentImage_random == true {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { // 뷰안정을 위해, DispatchQueue
//                        currentImage_random = images.randomElement() ?? "object_RockPaperScissors_Paper"
//                        // 디버깅용
//                        printCurrentTime()
//                        print("새 랜덤이미지 선정")
//                    }
//                }
//        }
//        
//        // 게임의 승부가 정해지면, 3초 기다린 뒤 3,2,1을 하고, 한 번 더 겨룸.
//        .onChange(of: determinedGameResult) {
//            if determinedGameResult == true {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                    currentImage_random = " " // 현재 이미지 삭제
//                    startCountdown() // 321 시작
//                }
//            }
//        }
        
        // 두 개 합쳐서 해볼까? (3시 10분)
        .onChange(of: prepCount){
            if prepCount == nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    currentImage_random = " " // 현재 이미지 삭제
                    startCountdown() // 321 시작
                }
            }
        }
        
    } // var.body.some.view 끝
    
    private func startCountdown() {
        
        //디버깅용
        printCurrentTime()
        print("카운트다운 시작")
        
        // 각 이미지가 1초 간격으로 표시
        for i in 0...2 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    prepCount = i
                }
            }
        }
        
        // 마지막 이미지 이후 랜덤 이미지가 나타나는 타이밍
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                prepCount = nil
                showCurrentImage_random = true
                
                // 디버깅용
                printCurrentTime()
                print("showCurrentImage_random 값: \(showCurrentImage_random)")
                determinedGameResult = false
                print("determinedGameResult 값: \(determinedGameResult)")
            }
        }
    }
}

// 승패 확인 케이스
func determinewin (player : String, computer: String) -> String {
    switch (player, computer) {
    case ("rock", "object_RockPaperScissors_Scissors3"), ("scissors", "object_RockPaperScissors_Paper3"), ("paper", "object_RockPaperScissors_Rock3"):
        return "Win"
    case ("scissors", "object_RockPaperScissors_Rock3"), ("paper", "object_RockPaperScissors_Scissors3"), ("rock", "object_RockPaperScissors_Paper3"):
        return "Try Again"
    case ("scissors", "object_RockPaperScissors_Scissors3"), ("paper", "object_RockPaperScissors_Paper3"), ("rock", "object_RockPaperScissors_Rock3"):
        return "Same"
    default:
        return "nil"
    }
    
}
















// AR 카메라 기능
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
    @Binding var showCurrentImage_random : Bool // 기존에 떠있는 가위바위보 이미지
    
    // 반복과 관련있는 변수들
    @State var repeatCount = 0 // 몇 회 반복 이겼는지 - 현황
    @Binding var repeatNumber : Int // 몇 회차까지 이겨야 하는지 - 목표
    @Binding var determinedGameResult : Bool // 게임이 이긴 상태인지 진 상태인지
    
    var result: String {
        determinewin(player: labelText, computer: currentImage_random)
    }
    
    private func countUpdate() {
        repeatCount += 1
    }
    
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
                        Text(resultText)
                        // 결과 텍스트를 표시
                            .font(.system(size: 100, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .shadow(color: .yellow, radius: 10)
                            .padding(.bottom, 50)
                        
                    } else {
                        Text("Please choose between \nrock, paper, scissors.")
                            .foregroundColor(.black)
                            .background(.white.opacity(0.4))
                            .padding(.bottom, 50)
                    }
                    
                }
                // 새창이 뜨기 때문에 필요없어짐.
//                else {
//                    Text("You did a GOOD JOB!")
//                        .font(.system(size: 50, weight: .bold))
//                        .foregroundColor(.red)
//                        .padding(.bottom, 50)
//                }
            }
            
        }
        // [구형, 321 적용 전] 화면 뜨자마자 승패 가리는 구조 // confidenceValue는 0.5초마다 점검함.
        .onChange(of: confidenceValue) { newValue in
            
            if newValue > 80 && repeatCount < repeatNumber && !determinedGameResult && showCurrentImage_random {
                processGameResult()
            }
        }
        
        // 게임 화면 전환용 (Hooray!)
        .onAppear {
            if repeatCount >= repeatNumber {
                showFullScreenView = true // 게임이 끝나면 전체 화면 전환
            }
        }
        .sheet(isPresented: $showFullScreenView) {
            RockPaperScissors3() // Present full-screen view
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
        
        // 디버깅용
        printCurrentTime()
        print("Process Game result 호출")
        
        let gameResult = result
        
        if gameResult == "Win" {
            repeatCount += 1
            resultText = "WIN!"

            // 게임 결과가 나왔을 때, [디버깅용]
            determinedGameResult = true
            currentImage_random = " " // 평소에 닫아두기
            printCurrentTime()
            print("result 3초 보여준 후, 재시작")
            
        } else if gameResult == "Try Again" {
            resultText = "Try Again!"
            
            // 게임 결과가 나왔을 때, [디버깅용]
            determinedGameResult = true
            currentImage_random = " " // 평소에 닫아두기
            printCurrentTime()
            print("result 3초 보여준 후, 재시작")
            
        } else if gameResult == "Same" {
            resultText = "It's tied!"
            
            // 게임 결과가 나왔을 때, [디버깅용]
            determinedGameResult = true
            currentImage_random = " " // 평소에 닫아두기
            printCurrentTime()
            print("result 3초 보여준 후, 재시작")
        }
        
        if repeatCount >= repeatNumber {
            showFullScreenView = true
        }
        
        // 게임의 승부가 정해진 후 3초 뒤 (자동)재시작 [필요시 DispatchQueue]  // DispatchQueue.main.asyncAfter(deadline: .now() + 3) {}
//        // 게임 결과가 나왔을 때, [디버깅용]
//        determinedGameResult = true
//        printCurrentTime()
//        print("result 3초 보여준 후, 재시작")
        
        

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


#Preview{
    @Previewable @State var currentStep: Int = 2
    @Previewable @State var currentImage_random: String = "object_RockPaperScossprs_Rock3"
    @Previewable @State var repeatNumber: Int = 2
    RockPaperScissors2(currentStep: $currentStep, currentImage_random: $currentImage_random, repeatNumber: $repeatNumber)
}
