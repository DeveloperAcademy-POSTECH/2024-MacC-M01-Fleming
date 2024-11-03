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
    @StateObject private var soundManager = SoundManager()
    
    
    var body: some View {
        
        ZStack{
            BaseView_ThreeLittlePig(currentStep:$currentStep)
            
            // 페이지 이동 버튼
            ButtonView_ThreeLittlePig(currentStep: $currentStep)
                .frame(width:screenWidth-100, height: screenHeight-110, alignment: .bottom)
            
            // 캐릭터 띄우기
            HStack{
                Image("character_ThreeLittlePig1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.5) // 화면 크기 n배
                    .offset(x:  -screenWidth*0.15, y: isLeft ? screenHeight*0.1 : screenHeight*0.12)
                    .animation(.easeInOut(duration: 0.3), value: isLeft)
                    .onReceive(timer) { _ in
                        // 0.5초마다 좌우 위치를 변경
                        isLeft.toggle()
                    }
            }
            
        }.onAppear {     // personal voice by hera start
            //checkAuthorization()
            soundManager.speakText("""
                    The first pig wanted to build a house with straw.
            """)
        }
        .onDisappear(){
            soundManager.stopSpeaking()
        }
    }
}

#Preview {
    @Previewable @State var isLeft: Bool = false
    ThreeLittlePigs02(currentStep: .constant(2), isLeft: $isLeft)
}
