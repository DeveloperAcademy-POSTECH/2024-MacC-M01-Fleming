//
//  RockPaperScissors1.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/18/24.
//

import SwiftUI

struct RockPaperScissors1: View{
    @State private var isActive = false
    
    //임시: 페이지 넘기기
    @State private var isPresentingNextPage = false
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View{

        // 시작화면
        ZStack{
            Rectangle()
                .foregroundStyle(Color(AppColor.handColor))
                .edgesIgnoringSafeArea(.all)

            VStack{
                Text("Rock Paper Scissors !")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundStyle(.blue)
                    .padding(.bottom, screenHeight * 0.1)
                
                HStack{
                    Image("object_RockPaperScissors_Rock")
                        .frame(height: screenHeight * 0.2)
                    
                    Image("object_RockPaperScissors_Paper")
                        .frame(height: screenHeight * 0.2)
                        .padding(screenWidth * 0.05)
                    
                    Image("object_RockPaperScissors_Scissors")
                        .frame(height: screenHeight * 0.2)
                }
                .padding(.bottom, screenHeight * 0.1)
                
            }
            
            Button (action: {
                isPresentingNextPage = true
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
                .offset(x: screenWidth/2 - 150, y: screenHeight / 2 - 60)
                    .padding(.trailing, 40)
            })
            
        }
        //임시: 페이지 넘기기
        .fullScreenCover(isPresented: $isPresentingNextPage){
            RockPaperScissors2()
        }
    }
}

#Preview{
//    @Previewable @State var isPresentingNextPage: Bool = false
    RockPaperScissors1()
}