//
//  SoundLevelView.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/16/24.
//

import SwiftUI

struct SoundLevelView: View {
    @ObservedObject var audioManager = AudioManager() // 오디오 매니저 연결
    
    // 데시벨 넘는 횟수 카운트용(dBCounter)
    private let columns = Array(repeating: GridItem(.flexible()), count: 10) // 체크마크 열의 수를 설정(dBCounter)
    @State private var thresholdValue: Float = 50.0 // 초기 데시벨 기준 값
    
    // FullScreenCove 해제용
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack{
            Spacer()
            
            HStack {
                Button(action: {
                    dismiss() // 모달 닫기
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("동화책으로 돌아가기")
                    }
                    .font(.title)
                    .padding()
                    .background(Color.blue.opacity(0.8))
                    .cornerRadius(8)
                    .foregroundStyle(.white)
                }
                Spacer()
            }
            .padding()
            
            Spacer()
            
            HStack {
                VStack {
                    Text("실시간 소리 크기 게이지 (dB)")
                        .font(.title)
                        .padding()
                    
                    // 실시간 소리 크기를 그래프로 표시 (막대 그래프)
                    ZStack(alignment: .bottom) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 100, height: 300)
                        
                        Rectangle()
                            .fill(Color.green)
                            .frame(width: 100, height: CGFloat(audioManager.soundLevel / 160) * 300) // 데시벨을 높이로 변환
                    }
                    .cornerRadius(10)
                    .padding()
                    
                    Text("현재 소리 크기: \(Int(audioManager.soundLevel)) dB")
                        .font(.headline)
                        .padding()
                }
                
                Spacer()
                
                // 실시간 소리 크기 그래프 (시간 축 기반)
                VStack {
                    HStack{
                        Text("실시간 소리 크기 그래프 (dB)")
                            .font(.title)
                            .padding()
                            .frame(alignment: .leading)
                        Spacer()
                    }
                    
                    GeometryReader { geometry in
                        let height = geometry.size.height
                        let width = geometry.size.width / 2 // 그래프 너비를 절반으로 줄임
                        let maxPoints = 100
                        
                        // Y축 축좌표
                        ZStack(alignment:.leading) {
                            // 축 좌표 라벨
                            VStack {
                                Text("160 dB")
                                    .font(.caption)
                                Spacer()
                                Text("80 dB")
                                    .font(.caption)
                                Spacer()
                                Text("0 dB")
                                    .font(.caption)
                            }
                            .frame(width: 40) // Y축 라벨의 너비
                            .padding(.trailing, 4)
                            
                            // 그래프 라인
                            Path { path in
                                if !audioManager.soundLevels.isEmpty {
                                    // 그래프 시작점
                                    let firstY = height * (1 - CGFloat(audioManager.soundLevels.first! / 160))
                                    path.move(to: CGPoint(x: 0, y: firstY))
                                    
                                    // 소리 크기 데이터에 따라 그래프 그리기
                                    for (index, level) in audioManager.soundLevels.enumerated() {
                                        let x = CGFloat(index) / CGFloat(maxPoints) * width
                                        let y = height * (1 - CGFloat(level / 160))
                                        path.addLine(to: CGPoint(x: x, y: y))
                                    }
                                }
                            }
                            .stroke(Color.blue, lineWidth: 2)
                            .frame(width: width) // 그래프의 너비를 절반으로 줄임
                        }
                    }
                    .frame(height: 200)
                    .padding()
                }
                
                Spacer()
                
                // dBCounter 모음
                VStack{
                    
                    // 제목
                    HStack{
                        Text("기준데시벨 넘었는지 체크용")
                            .font(.title)
                            .padding()
                            .frame(alignment: .leading)
                        Spacer()
                    }
                    
                    // 슬라이더
                    Text("데시벨 기준 값: \(Int(thresholdValue)) dB")
                        .font(.headline)
                        .padding()
                    
                    Slider(value: $thresholdValue, in: 0...160, step: 1) {
                        Text("Threshold")
                    }
                    .onChange(of: thresholdValue) { newValue in
                        audioManager.threshold = thresholdValue
                    }
                    .padding()
                    
                    // 실제 체크용: 일정 데시벨 넘어간 수만큼 체크마크 아이콘을 표시(dbCounter)
                    Text("Total Counting: \(audioManager.dBCounter)")
                        .font(.headline)
                        .padding()
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 10), spacing: 10) {
                        ForEach(0..<min(audioManager.dBCounter, 100), id: \.self) { index in
                            VStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.title)
                                    .frame(width: 30, height: 30)
                                
                                // 몇 dB을 넘었는지 기록용
                                if index < audioManager.thresholdHistory.count {
                                    Text("\(Int(audioManager.thresholdHistory[index])) dB")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .onAppear {
                audioManager.setupRecorder() // 뷰가 나타날 때 오디오 레코더 시작
            }
            
            Spacer()
        }
    }
}

#Preview {
    SoundLevelView()
}
