//
//  ThreeLittlePigs2.swift
//  Fleming_App
//
//  Created by Leo Yoon on 11/5/24.
//

import SwiftUI

struct ThreeLittlePigs2: View {
    @Binding var currentStep: Int
    @Binding var isLeft: Bool
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect() // 0.5초 간격 타이머
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    @StateObject private var soundManager = SoundManager()
    
    var body: some View {
        
        ZStack{
            BaseView_ThreeLittlePig(currentStep:$currentStep)
            
            // 캐릭터 나타내는 뷰
            ThreeLittlePigs2_sub(currentStep: $currentStep, isLeft: $isLeft) // 뷰 안그려짐이슈 해결을 위해 분리...
            
            // 페이지 이동 버튼
            ButtonView_ThreeLittlePig(currentStep: $currentStep)
                .frame(width:screenWidth-100, height: screenHeight-110, alignment: .bottom)
            
        }.onAppear {
            // TTS 읽어주기 시작.
            playTTS()
        }
        
        // personal voice Stop
        .onDisappear(){
            soundManager.stopSpeaking()
        }
        
        // 애니메이션 작동
        .onReceive(timer) { _ in
            isLeft.toggle() // 0.5초마다 좌우 위치를 변경
        }
    }
    
    // 현재 스텝에 따라 사운드를 재생하는 함수
    private func playTTS() {
        switch currentStep {
        case 2:
            soundManager.speakText("The first pig wanted to build a house with straw.")
        case 5:
            soundManager.speakText("The second pig wanted to build a house with sticks.")
        case 8:
            soundManager.speakText("The third pig wanted to build a house with bricks.")
        default:
            break
        }
    }
}

// 캐릭터를 선택하여 띄우는 뷰 - currentStep에 따라
struct ThreeLittlePigs2_sub: View {
    @Binding var currentStep: Int
    @Binding var isLeft: Bool
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        let imageName: String
        switch currentStep {
        case 2:
            imageName = "character_ThreeLittlePig1"
        case 5:
            imageName = "character_ThreeLittlePig2"
        case 8:
            imageName = "character_ThreeLittlePig3"
        default:
            imageName = ""
        }
        
        return Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: screenWidth * 0.5)
            .offset(x: -screenWidth * 0.15, y: isLeft ? screenHeight * 0.1 : screenHeight * 0.12)
            .animation(.easeInOut(duration: 0.3), value: isLeft)
    }
}

#Preview {
    @Previewable @State var isLeft: Bool = false
    ThreeLittlePigs2(currentStep: .constant(2), isLeft: $isLeft)
}
