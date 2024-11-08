//
//  RockPaperScissors0.swift
//  Fleming_App
//
//  Created by 임유리 on 11/3/24.
//


import SwiftUI

struct RockPaperScissors0: View{
//    @State private var isActive = false
    @Binding var currentStep: Int
//    
    //임시: 페이지 넘기기
//    @State private var isPresentingNextPage = false
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

//    @Binding var isLeft : Bool

    
    var body: some View {

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
            
        }
    }
}

#Preview{
    @Previewable @State var currentStep: Int = 0
    RockPaperScissors0(currentStep: $currentStep)
}
