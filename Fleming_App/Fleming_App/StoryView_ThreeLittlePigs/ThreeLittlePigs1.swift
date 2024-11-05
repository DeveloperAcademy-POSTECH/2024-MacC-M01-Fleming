//
//  ThreeLittlePigs1.swift
//  Fleming_App
//
//  Created by Leo Yoon on 11/5/24.
//
//

import SwiftUI
import AVFoundation

struct ThreeLittlePigs1: View {
    @Binding var currentStep: Int
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    @Binding var isLeft : Bool
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    // AVSpeech 관련 상태들
    // by hera
    @State private var authorStatus: AVSpeechSynthesizer.PersonalVoiceAuthorizationStatus = .notDetermined
    @State private var personalVoices: [AVSpeechSynthesisVoice] = []
    let synthesizer = AVSpeechSynthesizer()
    @StateObject private var soundManager = SoundManager()

    
    
    var body: some View {
        ZStack {
            // 배경 및 캐릭터 배치
            BaseView_ThreeLittlePig(currentStep: $currentStep)

            HStack {
                // 캐릭터 이미지들
                Image("character_ThreeLittlePig1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.35) // 화면 크기 n배
                    .offset(x:  -screenWidth*0.15, y: isLeft ? screenHeight*0.2 : screenHeight*0.18)

                    .animation(.easeInOut(duration: 0.3), value: isLeft)
//                    .onReceive(timer) { _ in
//                        isLeft.toggle()
//                    }
                
                Image("character_ThreeLittlePig2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.35) // 화면 크기 n배
                    .offset(x:  -screenWidth*0.15, y: isLeft ? screenHeight*0.19 : screenHeight*0.21)

                    .animation(.easeInOut(duration: 0.2), value: isLeft)
//                    .onReceive(timer) { _ in
//                        isLeft.toggle()
//                    }
                    .padding(-200)
                
                Image("character_ThreeLittlePig3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.35) // 화면 크기 n배
                    .offset(x: -screenWidth*0.15, y: isLeft ? screenHeight*0.23 : screenHeight*0.21)

                    .animation(.easeInOut(duration: 0.3), value: isLeft)
//                    .onReceive(timer) { _ in
//                        isLeft.toggle()
//                    }
                    .padding(-20)

            }
            .offset(x: screenWidth/3, y: -screenHeight/20)
            // 애니메이션 작동
            .onReceive(timer) { _ in
                isLeft.toggle() // 0.5초마다 좌우 위치를 변경
            }
            
            // 제목 - 컴포넌트화 필요
            VStack{
                Text("The Three")

                    .font(.system(size: 128))
                    .bold()
                    .frame(width: screenWidth-80, alignment: .leading)
                    .foregroundStyle(AppColor.pigBrown)
                Text("Little Pigs")
                    .font(.system(size: 128))
                    .bold()
                    .frame(width: screenWidth-80, alignment: .leading)
                    .foregroundStyle(AppColor.pigBrown)
            }
            .padding(.leading, 40)
            .padding(.bottom, screenHeight*0.5)

            // 페이지 이동 버튼
            ButtonView_ThreeLittlePig(currentStep: $currentStep)
                .frame(width:screenWidth-100, height: screenHeight-110, alignment: .bottom)
        }
        .onAppear {
            // TTS 읽어주기 시작.
            soundManager.speakText("""
                    The Three Little Pigs...
                    A long, long time ago, there were three little pigs.
            """)
        }
        
        // personal voice Stop
        .onDisappear(){
            soundManager.stopSpeaking()
        }
        .alert(isPresented: .constant(authorStatus == .denied)) {
            Alert(
                title: Text("개인음성 권한 거부됨"),
                message: Text("개인 음성 권한이 거부되었습니다. 설정에서 권한을 허용해주세요."),
                dismissButton: .default(Text("확인"))
            )
        }
    }
}

#Preview {
    @Previewable @State var isLeft: Bool = false
    ThreeLittlePigs1(currentStep: .constant(1), isLeft: $isLeft)
}
