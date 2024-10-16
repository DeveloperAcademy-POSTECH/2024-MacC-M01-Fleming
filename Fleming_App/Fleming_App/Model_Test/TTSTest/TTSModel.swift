//
//  TTSModel.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/16/24.
//

import AVFoundation
import SwiftUI

class TTSViewModel: ObservableObject {
    private let synthesizer = AVSpeechSynthesizer()
    
    // 읽어줄 텍스트를 저장하는 변수
    let textToRead: String = "This is a simple TTS example."
    
    // 선택된 목소리를 저장하는 변수
    @Published var selectedVoiceIdentifier: String? = nil

    // 초기화 시 오디오 세션 설정
    init() {
        configureAudioSession()
    }
    
    // 기기에서 사용할 수 있는 목소리 목록
    var availableVoices: [AVSpeechSynthesisVoice] {
        return AVSpeechSynthesisVoice.speechVoices()
    }
    
    // 텍스트를 읽어주는 함수
    func speak() {
        // 현재 재생 중인 음성을 중지
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: textToRead)
        
        // 선택된 목소리 설정
        if let voiceIdentifier = selectedVoiceIdentifier,
           let selectedVoice = AVSpeechSynthesisVoice(identifier: voiceIdentifier) {
            utterance.voice = selectedVoice
        } else {
            // 기본 설정
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        }
        
        synthesizer.speak(utterance)
    }
    
    // 오디오 세션 설정 함수
    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.duckOthers])
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
    }
}




struct SimpleTTSView: View {
    @StateObject private var viewModel = TTSViewModel()

    var body: some View {
        VStack {
            // 목소리 선택 Picker
            Picker("Select Voice", selection: $viewModel.selectedVoiceIdentifier) {
                Text("Default").tag(nil as String?)
                ForEach(viewModel.availableVoices, id: \.identifier) { voice in
                    Text(voice.name).tag(voice.identifier as String?)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            
            Button(action: {
                viewModel.speak()
            }) {
                HStack {
                    Image(systemName: "speaker.wave.2.fill")
                    Text("Read Text")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
    }
}

struct SimpleTTSView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleTTSView()
    }
}
