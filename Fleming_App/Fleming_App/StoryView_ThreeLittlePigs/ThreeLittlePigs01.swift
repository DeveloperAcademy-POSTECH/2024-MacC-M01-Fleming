//
//  Untitled.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/10/24.
//
//

import SwiftUI
import AVFoundation

struct ThreeLittlePigs01: View {
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

    var body: some View {
        ZStack {
            // 배경 및 캐릭터 배치
            BaseView_ThreeLittlePig(currentStep: $currentStep)

            HStack {
                // 캐릭터 이미지들
                Image("character_ThreeLittlePig1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth * 0.35)
                    .offset(x: -250, y: isLeft ? 200 : 190)
                    .animation(.easeInOut(duration: 0.3), value: isLeft)
                    .onReceive(timer) { _ in
                        isLeft.toggle()
                    }
                
                Image("character_ThreeLittlePig2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.35)
                    .offset(x: -210, y: isLeft ? 180 : 170)
                    .animation(.easeInOut(duration: 0.2), value: isLeft)
                    .onReceive(timer) { _ in
                        isLeft.toggle()
                    }
                    .padding(-200)
                
                Image("character_ThreeLittlePig3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.35)
                    .offset(x: -170, y: isLeft ? 180 : 170)
                    .animation(.easeInOut(duration: 0.3), value: isLeft)
                    .onReceive(timer) { _ in
                        isLeft.toggle()
                    }
                    .padding(-20)

            }
            .offset(x: screenWidth / 3, y: -screenHeight / 20)

            // 제목
            VStack {
                Text("The")
                    .font(.system(size: 128))
                    .bold()
                    .frame(width: screenWidth-80, alignment: .leading)
                    .foregroundStyle(AppColor.pigBrown)
                Text("Three")
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

            // 페이지 이동 버튼
            ButtonView_ThreeLittlePig(currentStep: $currentStep)
                .frame(width: screenWidth - 80, height: screenHeight - 80, alignment: .bottom)
        }
        .onAppear {     // personal voice by hera start
            checkAuthorization()
        }
        .alert(isPresented: .constant(authorStatus == .denied)) {
            Alert(
                title: Text("개인음성 권한 거부됨"),
                message: Text("개인 음성 권한이 거부되었습니다. 설정에서 권한을 허용해주세요."),
                dismissButton: .default(Text("확인"))
            )
        }
    }

    func checkAuthorization() {
        authorStatus = AVSpeechSynthesizer.personalVoiceAuthorizationStatus
        switch authorStatus {
        case .authorized:
            listPersonalVoices()
            startRunText()
        case .denied:
            print("개인 음성 권한 거부됨.")
        case .notDetermined:
            AVSpeechSynthesizer.requestPersonalVoiceAuthorization { newStatus in
                DispatchQueue.main.async {
                    authorStatus = newStatus
                    if newStatus == .authorized {
                        listPersonalVoices()
                        startRunText()
                    } else {
                        print("개인 음성 권한이 승인되지 않음.")
                    }
                }
            }
        case .unsupported:
            print("이 기기는 개인 음성을 지원하지 않습니다.")
            startRunText() // 지원되지 않으면 기본 음성 재생으로
        @unknown default:
            print("알 수 없는 개인 음성 권한 상태.")
        }
    }

    // 개인 음성 목록 가져오기
    func listPersonalVoices() {
        personalVoices = AVSpeechSynthesisVoice.speechVoices().filter { $0.voiceTraits.contains(.isPersonalVoice) }
        if personalVoices.isEmpty {
            print("개인 음성이 없습니다.")
        } else {
            print("개인 음성 목록: \(personalVoices)")
        }
    }
    func startRunText() {
        DispatchQueue.main.async {
            // 메인 스레드에서 실행
            let utterance = AVSpeechUtterance(string: """
            The Three Little Pigs
            Once upon a time, there were three little pigs. They each decided to build their own house.
            """)
            
            if let customVoice = personalVoices.first {
                utterance.voice = customVoice
            } else {
                utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            }

            utterance.rate = 0.5
            synthesizer.speak(utterance)
        }
    }
}
