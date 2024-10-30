//
//  ButtonView_ThreeLittlePig.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/16/24.
//

import SwiftUI

struct ButtonView_ThreeLittlePig: View{
    @Binding var currentStep: Int
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var body: some View{
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
            
            if (currentStep >= 18){
                Text("")
            } else {
                Button(action: {
                    if (currentStep == 18){
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
        }
        .frame(width:screenWidth-80, height: screenHeight-80, alignment: .bottom)
    }
}
