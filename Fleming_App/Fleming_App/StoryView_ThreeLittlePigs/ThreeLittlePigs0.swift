
//
//  ThreeLittlePigs0.swift
//  Fleming_App
//
//  Created by Leo Yoon on 11/1/24.
//

import SwiftUI
import AVFoundation

struct ThreeLittlePigs0: View {
    @Binding var currentStep: Int
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    @Binding var isLeft : Bool
    
    var body: some View {
        ZStack {
            // 배경 및 캐릭터 배치
            BaseView_ThreeLittlePig(currentStep: $currentStep)
            
            HStack {
                // 캐릭터 이미지들
                Image("character_ThreeLittlePig1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.35) // 화면 크기 n배
                    .offset(x:  -screenWidth*0.15, y: isLeft ? screenHeight*0.2 : screenHeight*0.18)
                
                
                Image("character_ThreeLittlePig2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.35) // 화면 크기 n배
                    .offset(x:  -screenWidth*0.15, y: isLeft ? screenHeight*0.19 : screenHeight*0.21)
                    .padding(-200)
                
                Image("character_ThreeLittlePig3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.35) // 화면 크기 n배
                    .offset(x: -screenWidth*0.15, y: isLeft ? screenHeight*0.23 : screenHeight*0.21)
                    .padding(-20)
            }
            .offset(x: screenWidth/3, y: -screenHeight/20)
            
            // 스토리 제목
            VStack{
                Text("The Three")
                
                    .font(.system(size: 128))
                    .bold()
                    .frame(width: screenWidth-80, alignment: .leading)
                    .foregroundStyle(AppColor.pigBrown)
                Text("Little Pigs")
                    .font(.system(size: 128))
                    .bold()
                    .frame(width: screenWidth-80, alignment: .leading)
                    .foregroundStyle(AppColor.pigBrown)
            }
            .padding(.leading, 40)
            .padding(.bottom, screenHeight*0.5)
        }
    }
}

#Preview {
    @Previewable @State var isLeft: Bool = false
    ThreeLittlePigs0(currentStep: .constant(0), isLeft: $isLeft)
}
