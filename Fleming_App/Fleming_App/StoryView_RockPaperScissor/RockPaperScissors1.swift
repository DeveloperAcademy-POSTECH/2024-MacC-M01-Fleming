//
//  RockPaperScissors1.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/18/24.
//

import SwiftUI

struct RockPaperScissors1: View{
    @State private var isActive = false
    @Binding var currentStep: Int
    
    //임시: 페이지 넘기기
    @State private var isPresentingNextPage = false
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @State private var isPresented: Bool = true
    @State private var repeatNumber: Int = 1
    
    var body: some View{

        // 시작화면
        ZStack{
            Rectangle()
                .foregroundStyle(Color(AppColor.handColor))
                .edgesIgnoringSafeArea(.all)

            VStack{
                Text("Rock Paper Scissors !")
                    .font(.system(size: 96, weight: .bold))
                    .foregroundStyle(AppColor.handColor2)
                    .padding(.bottom, screenHeight * 0.1)
                
                HStack(spacing: screenWidth * 0.05){
                    Image("object_RockPaperScissors_Rock2")
                        .resizable()
                        .scaledToFit()
                        .frame(height: screenHeight * 0.4)
                    
                    Image("object_RockPaperScissors_Paper2")
                        .resizable()
                        .scaledToFit()
                        .frame(height: screenHeight * 0.4)
                    
                    Image("object_RockPaperScissors_Scissors2")
                        .resizable()
                        .scaledToFit()
                        .frame(height: screenHeight * 0.4)
                }
                .padding(.bottom, screenHeight * 0.1)
            }
            
            ZStack{
                Button (action: {
                    currentStep = 2
                }, label: {
                    ZStack{
                        Rectangle()
                            .foregroundStyle(.white)
                            .frame(width: 300, height: 80)
                            .clipShape(ButtonBorderShape.roundedRectangle(radius: 20))
                        
                        HStack(alignment: .center){
                            Text("Start game")
                            Image(systemName: "chevron.forward")
                        }
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.blue)
                    }
                })
            }
            .offset(x: screenWidth/2 - 130, y: screenHeight / 2 - 100)
            .padding(.trailing, 120)
            
        }
    }
}

#Preview{
    @Previewable @State var currentStep: Int = 1
    RockPaperScissors1(currentStep: $currentStep)
}
