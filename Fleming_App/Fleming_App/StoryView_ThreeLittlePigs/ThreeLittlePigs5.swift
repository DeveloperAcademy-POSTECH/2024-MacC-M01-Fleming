//
//  ThreeLittlePigs5.swift
//  Fleming_App
//
//  Created by Leo Yoon on 11/5/24.
//

import SwiftUI

struct ThreeLittlePigs5: View {
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
            
            // 그림(좌측 상단부터 입력하기)
            Image("character_ThreeLittlePig4")
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth * 0.4) // 화면 크기 n배
                .offset(x: -screenWidth/3, y: isLeft ? screenHeight * 0.2 : screenHeight * 0.2 + 20)
                .animation(.easeInOut(duration: 0.5), value: isLeft) // 0.5초 간격 애니메이션
            
            Image("object_home11")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.3) // 화면 크기 n배
                .offset(x: 0, y: 100)
                .animation(.easeInOut(duration: 0.5), value: isLeft) // 0.5초 간격 애니메이션
            
            Image("object_home21")
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth * 0.3) // 화면 크기 n배
                .offset(x: screenWidth/5, y: 100)
                .animation(.easeInOut(duration: 0.5), value: isLeft) // 0.5초 간격 애니메이션
            
            Image("object_home31")
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth * 0.3) // 화면 크기 n배
                .offset(x: screenWidth / 5 * 2, y: screenHeight / 8)
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
                .frame(width:screenWidth-100, height: screenHeight-110, alignment: .bottom)
            
        }
        .onAppear{
            // 배경음악 재생 및 TTS 읽어주기 시작.
            soundModel.sampleMusicName = "music_sample1"
            soundModel.playSound()
            soundManager.speakText("""
                One day, a wolf came to the village where the pigs lived.
            """)
        }
        .onDisappear(){
            soundModel.stopSound()
        }
        
        // 애니메이션 작동
        .onReceive(timer) { _ in
            isLeft.toggle() // 0.5초마다 좌우 위치를 변경
        }
    }
}

#Preview {
    @Previewable @State var isLeft: Bool = false
    ThreeLittlePigs5(currentStep: .constant(11), isLeft:$isLeft)
}
