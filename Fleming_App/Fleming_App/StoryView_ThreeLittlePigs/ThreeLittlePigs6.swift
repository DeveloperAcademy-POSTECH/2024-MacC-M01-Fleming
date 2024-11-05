//
//  ThreeLittlePigs06.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/14/24.
//

import SwiftUI

struct ThreeLittlePigs6: View {
    @Binding var currentStep: Int
    @Binding var isLeft : Bool // 동그라미가 왼쪽에 있는지 여부
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect() // 0.5초 간격 타이머
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    @StateObject var soundModel = SoundPlayModel()
    @StateObject private var soundManager = SoundManager()

    var body: some View {
        
        ZStack{
            // 배경
            BaseView_ThreeLittlePig(currentStep:$currentStep)
            
            // 캐릭터(늑대)
            Image("character_ThreeLittlePig4")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.5) // 화면 크기 n배
                .offset(x: isLeft ? -screenWidth * 0.2 : -screenWidth * 0.2 - 20, y: screenHeight * 0.1 )
                .animation(.easeInOut(duration: 0.5), value: isLeft) // 0.5초 간격 애니메이션
            
            // 집
            Image(selectImage())
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.5) // 화면 크기 n배
                .offset(x: isLeft ? screenWidth * 0.2 : screenWidth * 0.2 + 20, y: screenHeight * 0.1 )
                .animation(.easeInOut(duration: 0.5), value: isLeft) // 0.5초 간격 애니메이션
            
            // 소리 재생 버튼 추가
            Button(action: {
                soundModel.playSound()
            }, label: {
                Image(systemName: "speaker.wave.2.fill")
                    .font(.system(size:40))
                    .bold()
                    .foregroundStyle(.orange)
            })
            .offset(x: screenWidth/2 - 60, y: -screenHeight/2 + 60)
            
            // 페이지 이동 버튼
            ButtonView_ThreeLittlePig(currentStep: $currentStep)
                .frame(width:screenWidth - 100, height: screenHeight - 110, alignment: .bottom)
            
        }
        .onAppear{
            // 배경음악 재생 및 TTS 읽어주기 시작.
            soundModel.sampleMusicName = "music_sample1"
            soundModel.playSound()
            playTTS()
        }
        
        .onDisappear(){
            soundModel.stopSound()
        }
        
        // 애니메이션 작동
        .onReceive(timer) { _ in
            isLeft.toggle() // 0.5초마다 좌우 위치를 변경
        }
    }
    
    // 현재 스텝에 따라 사운드를 재생하는 함수
    private func playTTS() {
        switch currentStep {
        case 12:
            soundManager.speakText("The wolf came to the first house.")
        case 14:
            soundManager.speakText("The wolf came to the second house.")
        case 16:
            soundManager.speakText("The wolf came to the third house.")
        default:
            break
        }
    }
    
    // (Image) 집 선택
    private func selectImage() -> String {
        let imageName: String
        switch currentStep {
        case 12:
            imageName = "object_home11"
        case 14:
            imageName = "object_home21"
        case 16:
            imageName = "object_home31"
        default:
            imageName = ""
        }
        return imageName
    }
}

#Preview {
    @Previewable @State var isLeft: Bool = false
    ThreeLittlePigs6(currentStep: .constant(12), isLeft:$isLeft)
}
