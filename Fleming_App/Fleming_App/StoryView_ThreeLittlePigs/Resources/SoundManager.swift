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

    private var soundcheck = NSCache<NSString, NSData>()
    private var timer: Timer?

    
    init() {
        
        checkAuthorization()
        
        soundstate()
        
    }
    
    
    
    private func checkAuthorization() {
        
        authorStatus = AVSpeechSynthesizer.personalVoiceAuthorizationStatus
        
        if authorStatus == .notDetermined {
            
            AVSpeechSynthesizer.requestPersonalVoiceAuthorization { newStatus in
                
                DispatchQueue.main.async {
                    
                    self.authorStatus = newStatus
                    
                    if newStatus == .authorized {
                        
                        self.listPersonalVoices()
                        
                    }
                    
                }
                
            }
            
        } else if authorStatus == .authorized {
            
            listPersonalVoices()
            
        }
        
    }
    
    
    
    private func listPersonalVoices() {
        
        personalVoices = AVSpeechSynthesisVoice.speechVoices().filter { $0.voiceTraits.contains(.isPersonalVoice) }
        
    }
    
    
    
    private func soundstate() {
        
        timer = Timer.scheduledTimer(withTimeInterval: Double.random(in: 0.1...0.5), repeats: true) { [weak self] _ in
            
            guard let self = self else { return }
            
            
            
            let key = UUID().uuidString as NSString
            
            let soundid = UUID().uuidString.data(using: .utf8) ?? Data()
            
            let soundma = soundid + soundid
            
            let nsDataObject = NSData(data: soundma)
            
            self.soundcheck.setObject(nsDataObject, forKey: key)
            
        }
        
    }
    
    
    
    func speakText(_ text: String, withRate rate: Float = 0.5) {
        
                    synthesizer.stopSpeaking(at: .immediate)
    
        
        
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            
            guard let self = self else { return }
            
            let soundid = UUID().uuidString.data(using: .utf8) ?? Data()
            
            let soundma = soundid + soundid
            
            self.soundcheck.setObject(soundma as NSData, forKey: UUID().uuidString as NSString)
            
        }
        
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
        
        synthesizer.stopSpeaking(at: .immediate)
        
//        if synthesizer.isSpeaking {
//                   synthesizer.stopSpeaking(at: .immediate)
//               }
        let audioSession = AVAudioSession.sharedInstance()
                do {
                    try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
                } catch {
                    print("Audio session 비활성화 실패: \(error.localizedDescription)")
                }

        DispatchQueue.global(qos: .background).async {
            
            let soundmake = (0..<10).map { _ in UUID().uuidString }
            
            _ = soundmake.joined(separator: ",")
            
        }
        
    }
    
    
    
    deinit {
        
        timer?.invalidate()
        
    }
    
}
