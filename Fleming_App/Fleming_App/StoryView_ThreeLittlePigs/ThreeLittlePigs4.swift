//  ThreeLittlePigs4.swift
//  Fleming_App
//
//  Created by Leo Yoon on 11/5/24.
//

import SwiftUI

struct ThreeLittlePigs4: View {
    @Binding var currentStep: Int
    @Binding var isLeft : Bool // 동그라미가 왼쪽에 있는지 여부
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect() // 0.5초 간격 타이머
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    @StateObject private var soundManager = SoundManager()
    
    var body: some View {
        
        ZStack{
            // 배경화면 뷰
            BaseView_ThreeLittlePig(currentStep:$currentStep)
            
            // 캐릭터를 선택하여 띄우는 뷰 - currentStep에 따라
            Image(selectImage1())
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth * 0.3)
                .offset(x:  -screenWidth * 0.15, y: isLeft ? screenHeight * 0.2 : screenHeight * 0.2 + 20)
                .animation(.easeInOut(duration: 0.3), value: isLeft)
            
            // 집을 선택하여 띄우는 뷰 - currentStep에 따라
            Image(selectImage2())
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.5) // 화면 크기 n배
//                .offset(x: isLeft ? 240 : 250, y: screenHeight * 0.07)
                .offset(x: 250, y: screenHeight * 0.07)
                .animation(.easeInOut(duration: 0.5), value: isLeft) // 0.5초 간격 애니메이션
            
        }.onAppear {
            // TTS 읽어주기 시작.
            playTTS()
        }
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
        case 4:
            soundManager.speakText("The first pig finished his straw house! Yay~!")
        case 7:
            soundManager.speakText("The second pig finished his stick house! Yay~!")
        case 10:
            soundManager.speakText("The third pig finished his brick house! Yay~!")
        default:
            break
        }
    }
    
    // (Image1) 캐릭터 선택
    private func selectImage1() -> String {
        let imageName: String
        switch currentStep {
        case 4:
            imageName = "character_ThreeLittlePig1"
        case 7:
            imageName = "character_ThreeLittlePig2"
        case 10:
            imageName = "character_ThreeLittlePig3"
        default:
            imageName = ""
        }
        return imageName
    }
    
    // (Image2) 집 선택
    private func selectImage2() -> String {
        let imageName: String
        switch currentStep {
        case 4:
            imageName = "object_home11"
        case 7:
            imageName = "object_home23"
        case 10:
            imageName = "object_home31"
        default:
            imageName = ""
        }
        return imageName
    }
}


#Preview {
    @Previewable @State var isLeft: Bool = false
    ThreeLittlePigs4(currentStep: .constant(10), isLeft:$isLeft)
}
