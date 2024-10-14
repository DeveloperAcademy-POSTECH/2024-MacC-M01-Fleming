//
//  SoundPlayModel.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/14/24.
//
import SwiftUI
import AVFoundation

class SoundPlayModel: ObservableObject {
    @Published var isPlaying: Bool = false
    var audioPlayer: AVAudioPlayer?
    var sampleMusicName: String = "music_sample_trial_1"
    
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
