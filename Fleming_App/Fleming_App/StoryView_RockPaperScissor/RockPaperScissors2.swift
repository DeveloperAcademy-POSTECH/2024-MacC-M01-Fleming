//
//  RockPapeerScissors2.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/18/24.
//

import SwiftUI

struct RockPaperScissors2: View{
    @ObservedObject var model = RockScissorsPaperMLModel()
    @State private var winnerCount = 0
    @Binding var currentStep: Int

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
                    
                    HStack(spacing: screenWidth * 0.1){
                        // 상대방 미리낼 것
                        VStack{
                            Text("Friend")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(.blue)
                            
                            ZStack{
                                Rectangle()
                                    .foregroundStyle(Color(AppColor.handBackgroundColor))
                                    .frame(width:screenHeight * 0.5, height: screenHeight * 0.5)
                                    .clipShape(ButtonBorderShape.roundedRectangle(radius: 50))
                                
                                Image("object_RockPaperScissors_Rock")
                                    .frame(width: screenHeight * 0.3)
                                
                            }
                        }
                        
                        // 내가 낼 것
                        VStack{
                            Text("Me")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(.blue)
                            
                            ZStack{
                                Rectangle()
                                    .foregroundStyle(Color(AppColor.handBackgroundColor))
                                    .frame(width:screenHeight * 0.5, height: screenHeight * 0.5)
                                    .clipShape(ButtonBorderShape.roundedRectangle(radius: 50))
                                
                                RSP_CameraView(model: model)
                                    .frame(width: screenHeight * 0.45, height: screenHeight * 0.45) // 카메라 뷰 크기를 500x500으로 설정
                                    .clipShape(RoundedRectangle(cornerRadius: 50))
                                    .clipped() // 부모 뷰 바깥의 콘텐츠를 자르기
                                    .rotationEffect(.degrees(90))
                                
                                Text("예측 결과: \(model.predictionLabel)")
                                    .font(.title2)
                                    .padding()
                            }
                        }
                    }
                    
                }
                
                Button(action: {
                    winnerCount += 1
                    if winnerCount >= 3{
                        currentStep = 3
                    }
                }, label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size:40))
                        .bold()
                        .foregroundStyle(.orange)
                })
                .offset(x: screenWidth/2 - 60, y: -screenHeight/2 + 60)
                
            }

    }
    
}

#Preview{
    @Previewable @State var currentStep: Int = 2
    RockPaperScissors2(currentStep: $currentStep)
}
