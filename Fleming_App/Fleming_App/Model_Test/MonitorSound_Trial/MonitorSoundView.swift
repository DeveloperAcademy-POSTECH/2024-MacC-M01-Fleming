//
//  MonitorSoundView.swift
//  BoBuSang_Trial
//
//  Created by Leo Yoon on 10/7/24.
//

import SwiftUI

struct MonitorSoundView: View {
    @ObservedObject var viewModel = MonitorSoundViewModel()
    @ObservedObject var cameraViewModel = CameraViewModel()
    
    var body: some View {
        ZStack {
            CameraView(viewModel: cameraViewModel)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    // 소리 재생/정지 버튼
                    Button(action: {
                        viewModel.togglePlayPause()
                    }) {
                        Text(viewModel.isPlaying ? "정지" : "소리재생")
                            .font(.title)
                            .padding()
                            .background(viewModel.isPlaying ? Color.red : Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 20)
                    
                    // 카메라 전환 버튼
                    Button(action: {
                        cameraViewModel.isUsingFrontCamera.toggle()
                        cameraViewModel.switchCamera()
                    }) {
                        Text("카메라 전환")
                            .font(.title)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .padding(.bottom, 40)
                    
                    // 동물 이동 버튼
                    Button(action: {
                        withAnimation(.easeInOut(duration: 2.0)) {
                            viewModel.animateCircle.toggle() // 애니메이션 트리거
                        }
                    }) {
                        Text("동물이동")
                            .font(.title)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 20)
                }
                .padding(.top, 40)
                
                Circle()
                    .fill(Color.red)
                    .frame(width: 50)
                    .offset(x: viewModel.animateCircle ? viewModel.xs_1 : viewModel.xs_2,
                            y: viewModel.animateCircle ? viewModel.ys_1 : viewModel.ys_2)
                    .animation(.easeInOut(duration: 2.0), value: viewModel.animateCircle)
                    .onAppear {
                        viewModel.calculatePositions()
                    }
            }
        }
    }
}

#Preview {
    MonitorSoundView()
}
