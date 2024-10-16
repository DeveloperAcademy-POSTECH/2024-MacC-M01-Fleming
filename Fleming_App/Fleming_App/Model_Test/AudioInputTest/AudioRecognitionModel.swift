//
//  AudioRecognitionModel.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/16/24.
//

import AVFoundation

class AudioManager: ObservableObject {
    private var audioRecorder: AVAudioRecorder?
    @Published var soundLevel: Float = 0.0 // 실시간 소리 크기
    @Published var soundLevels: [Float] = [] // 실시간으로 수집한 소리 크기 데이터
    
    init() {
        setupRecorder()
    }
    
    // 오디오 레코더 설정
    func setupRecorder() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .defaultToSpeaker)
            try audioSession.setActive(true)
            
            // 임시 경로에 빈 오디오 파일 생성
            let url = URL(fileURLWithPath: "/dev/null")
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatAppleLossless),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.isMeteringEnabled = true // 데시벨 측정 활성화
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            
            // 타이머를 통해 실시간 소리 크기 업데이트
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                self.updateSoundLevel()
            }
        } catch {
            print("Error setting up audio recorder: \(error)")
        }
    }
    
    // 데시벨 측정 업데이트
    func updateSoundLevel() {
        audioRecorder?.updateMeters()
        let averagePower = audioRecorder?.averagePower(forChannel: 0) ?? -160
        DispatchQueue.main.async {
            self.soundLevel = averagePower
            self.soundLevels.append(averagePower) // 소리 크기 저장
            
            // 데이터가 너무 많아지지 않도록 최근 100개의 데이터만 유지
            if self.soundLevels.count > 100 {
                self.soundLevels.removeFirst()
            }
        }
    }
}

//    // 데시벨을 [0, 1] 범위로 변환
//    private func normalizedSoundLevel(fromDecibels decibels: Float) -> Float {
//        let minDb: Float = -80.0
//        if decibels < minDb {
//            return 0.0
//        }
//        return (decibels + abs(minDb)) / abs(minDb)
//    }




