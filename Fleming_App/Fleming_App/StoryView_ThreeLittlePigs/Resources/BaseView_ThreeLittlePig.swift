//
//  BaseView_ThreeLittlePig.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/14/24.
// 베이스와 버튼

import SwiftUI

struct BaseView_ThreeLittlePig: View {
    @Binding var currentStep: Int
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var body: some View{
        // 배경
        Image("Background_ThreeLittlePig1")
            .resizable()
            .scaledToFill()
            .frame(width: screenWidth, height: screenHeight, alignment: .center)
            .offset(x:0, y:0)
            .edgesIgnoringSafeArea(.all)
        
        Image("Background_ThreeLittlePig2")
            .resizable()
            .scaledToFill()
            .frame(width: screenWidth, height: screenHeight, alignment: .center)
            .offset(x:0, y:0)
            .edgesIgnoringSafeArea(.all)
        
    }
}

#Preview{
    BaseView_ThreeLittlePig(currentStep: .constant(1))
}
