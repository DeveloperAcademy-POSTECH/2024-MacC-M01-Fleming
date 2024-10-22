//
//  SoundManager.swift
//  Fleming_App
//
//  Created by 임유리 on 10/22/24.
//

import SwiftUI
import AVFoundation

class SoundManager: ObservableObject {
    @Published var authorStatus: AVSpeechSynthesizer.PersonalVoiceAuthorizationStatus = .notDetermined
    @Published var personalVoices: [AVSpeechSynthesisVoice] = []
    private let synthesizer = AVSpeechSynthesizer()
    
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
        let utterance = AVSpeechUtterance(string: text)
        if let customVoice = personalVoices.first {
            utterance.voice = customVoice
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        }
        utterance.rate = rate
        synthesizer.speak(utterance)
    }
}
