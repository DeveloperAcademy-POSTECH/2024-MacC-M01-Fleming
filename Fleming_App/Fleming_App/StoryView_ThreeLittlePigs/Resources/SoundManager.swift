//
//  SoundManager.swift
//  Fleming_App
//
//  Created by 임유리 on 10/22/24.
//
// TTS 재생 모델
// (TTS 중지관련 부분은 Leo 수정본)
//

import SwiftUI
import AVFoundation

class SoundManager: ObservableObject {
    @Published var authorStatus: AVSpeechSynthesizer.PersonalVoiceAuthorizationStatus = .notDetermined
    @Published var personalVoices: [AVSpeechSynthesisVoice] = []
    private var synthesizer = AVSpeechSynthesizer()
    
//    // (init 변경안) 볼륨크기 환경객체 주입
//    private var settingVariables: SettingVariables
//    
//    init(settingVariables: SettingVariables) {
//            self.settingVariables = settingVariables
//            self.authorStatus = .notDetermined
//            self.personalVoices = []
//            self.synthesizer = AVSpeechSynthesizer()
//            // 모든 저장 프로퍼티 초기화 후 추가 설정 수행
//            self.initialize()
//        }
//    
//    private func initialize() {
//        checkAuthorization()
//    }
    
    init() {
        checkAuthorization()
    }

    private func checkAuthorization() {
        authorStatus = AVSpeechSynthesizer.personalVoiceAuthorizationStatus
        switch authorStatus {
        case .authorized:
            listPersonalVoices()
        case .denied, .unsupported:
            print("개인음성 권한 거부됨")
        case .notDetermined:
            AVSpeechSynthesizer.requestPersonalVoiceAuthorization { newStatus in
                DispatchQueue.main.async {
                    self.authorStatus = newStatus
                    if newStatus == .authorized {
                        self.listPersonalVoices()
                    } else {
                        print("개인음성 권한 승인되지 않음")
                    }
                }
            }
        @unknown default:
            print("알 수 없는 개인음성 권한 상태")
        }
    }

    private func listPersonalVoices() {
        personalVoices = AVSpeechSynthesisVoice.speechVoices().filter { $0.voiceTraits.contains(.isPersonalVoice) }
    }

    func speakText(_ text: String, withRate rate: Float = 0.5) {
        // 대화 시작시, 기존 말은 멈추고 시작하기.
        synthesizer.stopSpeaking(at: .immediate)
        
        // 0.4초 뒤에 TTS 시작
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            let utterance = AVSpeechUtterance(string: text)
            if let customVoice = self.personalVoices.first {
                utterance.voice = customVoice
            } else {
                utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            }
            utterance.rate = rate
//            utterance.volume = self.settingVariables.volumeBackground // volumeBackground 값 적용
            self.synthesizer.speak(utterance)
        }
    }
    
    func stopSpeaking() {
        // TTS 중지
        synthesizer.stopSpeaking(at: .immediate)
        
        // AVAudioSession도 활성화된 경우 중지
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session 비활성화 실패: \(error.localizedDescription)")
        }
    }
}
