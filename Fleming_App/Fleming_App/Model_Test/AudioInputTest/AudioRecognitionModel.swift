//
//  AudioRecognitionModel.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/16/24.
//

import AVFoundation

class AudioManager: ObservableObject {
    // Audio 기본세팅
    private var audioRecorder: AVAudioRecorder?
    @Published var soundLevel: Float = 0.1 // 실시간 소리 크기
    @Published var soundLevels: [Float] = [] // 실시간으로 수집한 소리 크기 데이터
    private let calibrationOffset: Float = 100.0 // 보정 계수 - 환경에 따라 직접 설정해야 함
    
    // 데시벨 오르내림 체크용(dBCounter)
    @Published var dBCounter: Int = 0 // 50dB 이상으로 올라갔다가 다시 내려갈 때마다 증가
    private var wasAboveThreshold: Bool = false
    var threshold: Float = 50.0 // 데시벨 기준 값
    @Published var thresholdHistory: [Float] = [] // threshold 값을 저장하는 배열(Test용)
    
    init() {
        setupRecorder()
    }
    
    // 오디오 레코더 설정
    func setupRecorder() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .voiceChat, options: [.defaultToSpeaker, .allowBluetooth, .allowBluetoothA2DP])
            try audioSession.setPreferredSampleRate(44100.0)
            try audioSession.setPreferredIOBufferDuration(0.02)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
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
        let calibratedDb = convertToDecibel(averagePower: averagePower)
        
        DispatchQueue.main.async {
            self.soundLevel = calibratedDb
            self.soundLevels.append(calibratedDb)
            
            // 데이터가 너무 많아지지 않도록 최근 100개의 데이터만 유지
            if self.soundLevels.count > 100 {
                self.soundLevels.removeFirst()
            }
            
            // 데시벨 넘은 횟수 증가 로직(dbCounter)
            self.checkForThresholdCrossing()
            
        }
    }
    
    // dBCounter 초기화 메서드
    func resetDBCounter() {
        dBCounter = 0
    }
    
    // AudioManager 종료 메서드
    func stopAudioManager() {
        audioRecorder?.stop()
        audioRecorder = nil
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Error deactivating audio session: \(error)")
        }
    }
    
    // 평균 전력을 실제 데시벨 값으로 변환
    private func convertToDecibel(averagePower: Float) -> Float {
        // 보정 계수를 적용하여 실제 데시벨로 변환
        return averagePower + calibrationOffset
    }
    
    // 기준 데시벨을 넘어갔다가 다시 내려오면 카운터 증가(dBCounter)
    private func checkForThresholdCrossing() {
        if soundLevel > threshold {
            wasAboveThreshold = true
        } else if wasAboveThreshold && soundLevel <= threshold {
            dBCounter += 1
            thresholdHistory.append(threshold) // 현재 threshold 값을 기록(test)
            wasAboveThreshold = false
        }
    }
    
}

