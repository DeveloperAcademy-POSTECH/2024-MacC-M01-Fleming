//
//  BaseView_ThreeLittlePig.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/14/24.
//

import SwiftUI

struct BaseView_ThreeLittlePig: View {
    @Binding var currentStep: Int
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var body: some View{
        // 배경
        Image("iPad mini 8.3 - _pig_background")
            .resizable()
            .scaledToFill()
            .frame(width: screenWidth, height: screenHeight, alignment: .center)
            .offset(x:0, y:0)
            .edgesIgnoringSafeArea(.all)
        
        // 뷰넘기기
        HStack(alignment: .bottom) {
            
            if (currentStep == 1){
                Text("")
            } else {
                Button(action:{
                    currentStep = currentStep - 1 // 전단계로 이동
                }, label:{
                    Image(systemName: "chevron.left")
                        .font(.system(size:40))
                        .bold()
                        .foregroundStyle(.cyan)
                })
            }
            
            Spacer()
            
            Button(action: {
                if (currentStep == 10){
                    currentStep = 1
                } else{
                    currentStep = currentStep + 1 // 다음 단계로 이동
                }
            }, label: {
                Image(systemName: "chevron.right")
                    .font(.system(size:40))
                    .bold()
                    .foregroundStyle(.cyan)
            })
        }
        .frame(width:screenWidth-80, height: screenHeight-80, alignment: .bottom)
    }
}

#Preview{
    BaseView_ThreeLittlePig(currentStep: .constant(1))
}