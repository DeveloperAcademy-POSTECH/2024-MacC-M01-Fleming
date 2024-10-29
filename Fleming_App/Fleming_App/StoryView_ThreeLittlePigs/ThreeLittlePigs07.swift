//
//  ThreeLittlePigs04.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/10/24.
//

import SwiftUI

struct ThreeLittlePigs07: View {
    @Binding var currentStep: Int
    @Binding var isLeft : Bool // 동그라미가 왼쪽에 있는지 여부
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect() // 0.5초 간격 타이머
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    @StateObject private var soundManager = SoundManager()
    
    var body: some View {
        
        ZStack{
            BaseView_ThreeLittlePig(currentStep:$currentStep)
            
            Image("object_home21")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.3) // 화면 크기 n배
                .offset(x: isLeft ? 240 : 260, y: 100)
                .animation(.easeInOut(duration: 0.5), value: isLeft) // 0.5초 간격 애니메이션
                .onReceive(timer) { _ in
                    // 0.5초마다 좌우 위치를 변경
                    isLeft.toggle()
                }
            
            // 페이지 이동 버튼
            ButtonView_ThreeLittlePig(currentStep: $currentStep)
                .frame(width:screenWidth-80, height: screenHeight-80, alignment: .bottom)
        }.onAppear(){soundManager.speakText("""
                    The second little pig gathered some wood to build a house.
                    The second little pig built a house with wood.
            """)}
        .onDisappear(){
            soundManager.stopSpeaking()
        }
    }
}

#Preview {
    @Previewable @State var isLeft: Bool = false
    ThreeLittlePigs07(currentStep: .constant(7), isLeft:$isLeft)
}
