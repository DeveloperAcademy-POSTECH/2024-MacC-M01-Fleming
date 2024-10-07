//
//  SoundPlayModel.swift
//  BoBuSang_Trial
//
//  Created by Leo Yoon on 10/7/24.
//

import SwiftUI
import AVFoundation

class MonitorSoundViewModel: ObservableObject {
    
    // 카메라 관련 변수
    @Published var isUsingFrontCamera: Bool = false
    
    // 소리 재생 변수
    @Published var isPlaying: Bool = false
    var audioPlayer: AVAudioPlayer?
    var sampleMusicName: String = "music_sample_trial_1"
    
    // 동물 이동 변수
    @Published var animateCircle: Bool = false
    let x_1: CGFloat = 10
    let x_2: CGFloat = 80
    let y_1: CGFloat = 20
    let y_2: CGFloat = 50
    @Published var xs_1: CGFloat = 0
    @Published var xs_2: CGFloat = 0
    @Published var ys_1: CGFloat = 0
    @Published var ys_2: CGFloat = 0
    
    // 위치 계산 함수
    func calculatePositions() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        xs_1 = (screenWidth / 100) * x_1 - (screenWidth / 2)
        xs_2 = (screenWidth / 100) * x_2 - (screenWidth / 2)
        ys_1 = (screenHeight / 100) * y_1 - (screenHeight / 2)
        ys_2 = (screenHeight / 100) * y_2 - (screenHeight / 2)
    }
    
    // 음악 재생 및 일시 정지 토글
    func togglePlayPause() {
        if isPlaying {
            audioPlayer?.stop()
        } else {
            playSound()
        }
        isPlaying.toggle()
    }
    
    // 로컬 사운드 재생
    func playSound() {
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
    
    // 카메라 전환
    func toggleCamera() {
        isUsingFrontCamera.toggle()
    }
}
