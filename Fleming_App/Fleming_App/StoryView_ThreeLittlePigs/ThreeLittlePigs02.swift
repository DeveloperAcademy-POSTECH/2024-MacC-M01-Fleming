//
//  ThreeLittlePigs02.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/10/24.
//

import SwiftUI

struct ThreeLittlePigs02: View {
    @Binding var currentStep: Int
    @Binding var isLeft : Bool // 동그라미가 왼쪽에 있는지 여부
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect() // 0.5초 간격 타이머
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    
    var body: some View {
        
        ZStack{
            
            BaseView_ThreeLittlePig(currentStep:$currentStep)
            
            // 페이지 이동 버튼
            ButtonView_ThreeLittlePig(currentStep: $currentStep)
                .frame(width:screenWidth-80, height: screenHeight-80, alignment: .bottom)
            
        }
    }
}

#Preview {
    @Previewable @State var isLeft: Bool = false
    ThreeLittlePigs02(currentStep: .constant(2), isLeft: $isLeft)
}
