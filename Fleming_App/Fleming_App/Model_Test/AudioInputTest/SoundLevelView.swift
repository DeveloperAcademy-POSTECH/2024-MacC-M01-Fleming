//
//  SoundLevelView.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/16/24.
//

import SwiftUI

struct SoundLevelView: View {
    @ObservedObject var audioManager = AudioManager() // 오디오 매니저 연결

    var body: some View {
        HStack {
            VStack {
                Text("실시간 소리 크기 (데시벨)")
                    .font(.title)
                    .padding()

                // 실시간 소리 크기를 그래프로 표시 (막대 그래프)
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 100, height: 300)

                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 100, height: CGFloat((audioManager.soundLevel + 160) / 160) * 300) // 데시벨을 높이로 변환
                }
                .cornerRadius(10)
                .padding()

                Text("현재 소리 크기: \(Int(audioManager.soundLevel)) dB")
                    .font(.headline)
                    .padding()
            }
            
            // 실시간 소리 크기 그래프 (시간 축 기반)
            VStack {
                Text("실시간 소리 크기 그래프 (데시벨)")
                    .font(.title)
                    .padding()

                GeometryReader { geometry in
                    Path { path in
                        let height = geometry.size.height
                        let width = geometry.size.width
                        let maxPoints = 100

                        if !audioManager.soundLevels.isEmpty {
                            // 그래프 시작점
                            let firstY = height * (1 - CGFloat((audioManager.soundLevels.first! + 160) / 160))
                            path.move(to: CGPoint(x: 0, y: firstY))

                            // 소리 크기 데이터에 따라 그래프 그리기
                            for (index, level) in audioManager.soundLevels.enumerated() {
                                let x = CGFloat(index) / CGFloat(maxPoints) * width
                                let y = height * (1 - CGFloat((level + 160) / 160))
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .stroke(Color.blue, lineWidth: 2)
                }
                .frame(height: 200)
                .padding()
            }
        }
        .onAppear {
            audioManager.setupRecorder() // 뷰가 나타날 때 오디오 레코더 시작
        }
    }
}

#Preview {
    SoundLevelView()
}
