//
//  RockPapeerScissors2.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/18/24.
//

import SwiftUI

//struct RockPaperScissors2: View{
//    @ObservedObject var model = RockScissorsPaperMLModel()
//    @State private var winnerCount = 0
//    @Binding var currentStep: Int
//
//    var screenWidth = UIScreen.main.bounds.width
//    var screenHeight = UIScreen.main.bounds.height
//    
//    var body: some View {
//
//            ZStack{
//                Image("Background_RPSView")
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: screenWidth, height: screenHeight, alignment: .center)
//                    .offset(x:0, y:0)
//                    .edgesIgnoringSafeArea(.all)
//                
//                VStack{
//                    
//                    Text("Rock Paper Scissors !")
//                        .font(.system(size: 80, weight: .bold))
//                        .foregroundStyle(.blue)
//                        .padding(.bottom, screenHeight * 0.05)
//                    
//                    HStack(spacing: screenWidth * 0.1){
//                        // 상대방 미리낼 것
//                        VStack{
//                            Text("Friend")
//                                .font(.system(size: 40, weight: .bold))
//                                .foregroundStyle(.blue)
//                            
//                            ZStack{
//                                Rectangle()
//                                    .foregroundStyle(Color(AppColor.handBackgroundColor))
//                                    .frame(width:screenHeight * 0.5, height: screenHeight * 0.5)
//                                    .clipShape(ButtonBorderShape.roundedRectangle(radius: 50))
//                                
//                                Image("object_RockPaperScissors_Rock")
//                                    .frame(width: screenHeight * 0.3)
//                                
//                            }
//                        }
//                        
//                        // 내가 낼 것
//                        VStack{
//                            Text("Me")
//                                .font(.system(size: 40, weight: .bold))
//                                .foregroundStyle(.blue)
//                            
//                            ZStack{
//                                Rectangle()
//                                    .foregroundStyle(Color(AppColor.handBackgroundColor))
//                                    .frame(width:screenHeight * 0.5, height: screenHeight * 0.5)
//                                    .clipShape(ButtonBorderShape.roundedRectangle(radius: 50))
//                                
//                                RSP_CameraView(model: model)
//                                    .frame(width: screenHeight * 0.45, height: screenHeight * 0.45) // 카메라 뷰 크기를 500x500으로 설정
//                                    .clipShape(RoundedRectangle(cornerRadius: 50))
//                                    .clipped() // 부모 뷰 바깥의 콘텐츠를 자르기
//                                    .rotationEffect(.degrees(90))
//                                
//                                Text("예측 결과: \(model.predictionLabel)")
//                                    .font(.title2)
//                                    .padding()
//                            }
//                        }
//                    }
//                    
//                }
//                
//                Button(action: {
//                    winnerCount += 1
//                    if winnerCount >= 3{
//                        currentStep = 3
//                    }
//                }, label: {
//                    Image(systemName: "speaker.wave.2.fill")
//                        .font(.system(size:40))
//                        .bold()
//                        .foregroundStyle(.orange)
//                })
//                .offset(x: screenWidth/2 - 60, y: -screenHeight/2 + 60)
//                
//            }
//
//    }
//    
//}
//
//#Preview{
//    @Previewable @State var currentStep: Int = 2
//    RockPaperScissors2(currentStep: $currentStep)
//}


struct RockPaperScissors2: View{
    @State private var winnerCount = 0 // 반복횟수 카운팅용
    @Binding var currentStep: Int // 현재 페이지
    
    // 랜덤 이미지 변수
    @State private var currentImageName: String = ""
    private let rockPaperScissorsImages = ["object_RockPaperScissors_Rock", "object_RockPaperScissors_Paper", "object_RockPaperScissors_Scissors"]
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
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
                                
                                Image("object_RockPaperScissors_Rock")
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
                                
                                RockPaperScissors_cam() // 현재는 신모델[ARKit], 구모델은 [Vision]활용한 RSP_CameraView(model: model)
//                                    .background(Color.brown) // ChildView의 영역 확인용.
//                                    .frame(width:screenHeight * 0.55, height: screenHeight * 0.55, alignment: .center) // 바로 카메라 왼쪽 위가 잘리는 현상 발생 (그 외에 frame은 정상범주) // .topLeading .center .bottomTrailing 모두 안됌. - edges Ignoring 하기 전
//                                    .frame(width:screenHeight * 0.55, height: screenHeight * 0.55, alignment: .center) // 잘림없이 밀리는 현상 발생 (edge ignoring 걸어두었을 때)
                                    .frame(width:screenHeight * 0.55, height: screenHeight * 0.55, alignment: .topLeading) // 영역은 정확함. RockPaperScissors_cam 내부에서 확인해봅시다.
                            }
                        }
                        Spacer()
                        
                    } // HStack 끝
                }
                
                Button(action: {
                    winnerCount += 1
                    if winnerCount >= 3{
                        currentStep = 3
                        currentImageName = rockPaperScissorsImages.randomElement() ?? "object_RockPaperScissors_Rock"
                    }
                }, label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size:40))
                        .bold()
                        .foregroundStyle(.orange)
                })
                .offset(x: screenWidth/2 - 60, y: -screenHeight/2 + 60)
                
            }
            .onAppear(){
                currentImageName = rockPaperScissorsImages.randomElement() ?? "object_RockPaperScissors_Rock"
            }
    }
    
}

struct RockPaperScissors_cam: View{
    @State private var labelText: String = "손 모양을 인식 중..."
    @State private var secondLabelText: String = "손 모양 상태"
    @State private var confidenceValue: Int = 0
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var body: some View{
        
        ZStack{
            ARViewContainer(labelText: $labelText, secondLabelText: $secondLabelText, confidenceValue: $confidenceValue) // 신형 (ARKit)
                .scaleEffect(0.55, anchor: .bottomTrailing)
                .offset(x: -screenWidth * 0.5 * 0.5, y: -screenHeight * 0.5 * 0.5) // (x,y) = (0,0)일 때, 밀려서 시도중... / 너무 많이 밀린다...
                .edgesIgnoringSafeArea(.all)
                .clipShape(RoundedRectangle(cornerRadius: 80))
            
            if confidenceValue > 80 {
                Text("예측 결과: \(labelText)")
                    .font(.title2)
                    .padding()
            } else {
                Text("가위, 바위, 보 중 선택하여 주세요.")
            }
        }   // .background(Color.green) // 화면크기는 ParentView와 동일한 것을 확인 함.
    
    }
}
