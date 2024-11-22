//
//  SoundPlayModel.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/14/24.
//
// 배경음악 재생모델
//
//

import SwiftUI
import AVFoundation

class SoundPlayModel: ObservableObject {
    @Published var isPlaying: Bool = false
    var audioPlayer: AVAudioPlayer?
    var sampleMusicName: String = "music_sample_trial_1"
    
//    // (init 변경안) 볼륨크기 환경객체 주입
//    private var settingVariables: SettingVariables
//    
//    init(settingVariables: SettingVariables) {
//        // settingVariables를 초기화
//        self.settingVariables = settingVariables
//        // 초기화 후 오디오 세션 설정
//        setupAudioSession()
//    }
//
    
    init() {
            setupAudioSession() // 오디오 세션 설정
        }
    
    // 오디오 세션 설정
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    

    
    // 로컬 사운드 재생
    func playSound() {
        // 기존 재생 중인 음악이 있으면 중지하고 초기화
        if let player = audioPlayer, player.isPlaying {
            player.stop()
            audioPlayer = nil // 기존 플레이어를 해제
        }
        
        // 새로운 사운드 파일 재생
        if let soundURL = Bundle.main.url(forResource: sampleMusicName, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
//                audioPlayer?.volume = settingVariables.volumeTTS // volumeTTS값 사용
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error)")
            }
        } else {
            print("Sound file not found.")
        }
    }
    
    // 음악 정지 메서드
    func stopSound() {
        audioPlayer?.stop()
        isPlaying = false
    }
}
