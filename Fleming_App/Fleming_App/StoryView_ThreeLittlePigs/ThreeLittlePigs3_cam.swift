
//
//  ThreeLittlePigs3_cam.swift
//  Fleming_App
//
//  Created by Leo Yoon on 11/5/24.
//


import SwiftUI
import Vision
import AVFoundation


struct ThreeLittlePigs3_cam: View {
    
    // by hera
    // 위치 지정용 변수(표적)
    @State private var touchPoint: CGPoint? = nil // 초기 이미지 위치 x는 300, y는 620
    @State private var imgPosition: CGPoint = CGPoint(
        x: UIScreen.main.bounds.width * 0.2,
        y: UIScreen.main.bounds.height * 0.7) // 초기 이미지 위치 x는 950, y는 620
    
    @Binding var currentStep: Int // currentStep 스토리 진행의 단계
    private let fingerCircleSize: CGFloat = 100.0 // 손가락 이미지 크기
    
    // 애니메이션 넣을 때 쓰는 변수(현재는 안 쓰임)
    @Binding var isLeft : Bool // 동그라미가 왼쪽에 있는지 여부
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect() // 0.5초 간격 타이머
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    @State private var isSuccess = false // 성공 여부를 나타내는 상태값
    @StateObject private var soundManager = SoundManager()
    
    // 반복연습과 관련있는 변수들
    @State var repeatCount = 0 // 몇 회 반복?
    @Binding var repeatNumber: Int
    @State private var refresh = false
    let refreshTime: TimeInterval = 3.0 // Success를 보고, 몇 초 뒤 별이 차오르는가?
    
    var body: some View {
        
        ZStack{
            
            // 카메라 뷰(배경깔기)
            makeCameraView(pos: $touchPoint, imgPosition: $imgPosition).edgesIgnoringSafeArea(.all)
            
            Rectangle()
                .fill(Color(hex: "#D9D9D9").opacity(0.36))
                .ignoresSafeArea()
//                .position(x:screenWidth / 2, y:screenHeight / 2)
            
            // 배경화면(초원)
            Image("Background_ThreeLittlePig2")
                .resizable()
                .scaledToFill()
                .frame(width: screenWidth, height: screenHeight, alignment: .center)
                .offset(x:0, y:0)
                .edgesIgnoringSafeArea(.all)
            
            
            // 집 옮기기 기능
            if isSuccess == false{
                Image(selectImage1())
                    .resizable()
                    .scaledToFit()
                    .opacity(0.8)
                    .frame(width: screenWidth * 0.4)
                    .offset(x: screenWidth * 0.3, y: screenHeight * 0.2)
                
                    GeometryReader { geometry in
                        Image(selectImage2()) // testimg 파일을 표시
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.4)
                            .position(imgPosition)
                            .onChange(of: imgPosition) { newPosition in
                                let targetX: CGFloat = screenWidth * 0.8
                                let targetY: CGFloat = screenHeight * 0.7
                                // -> targetX, targetY는 항상 아래의 완성된 집과 일치시킬 것
                            if abs(newPosition.x - targetX) < 50 && abs(newPosition.y - targetY) < 50 {
                                    withAnimation {
                                        isSuccess = true
                                    }
                                }
                            }
                    }
            }
                if let touchPoint = touchPoint {
                    
//                Circle()
//                    .fill(Color.red)
//                    .frame(width: 30, height: 30)
//                    .position(touchPoint)
                    
                    Image("handfinger")
                        .resizable()
                        .frame(width: fingerCircleSize, height: fingerCircleSize)
                        .position(touchPoint)
                    
            }
                if isSuccess {
                Text("Success!")
                    .font(.system(size:200, weight: .bold))
                    .foregroundColor(.yellow)
                    .bold()
                    .position(x: screenWidth / 2,
                              y: isLeft ? screenHeight * 0.4 - 30 : screenHeight * 0.4)
                    .animation(.easeInOut(duration: 0.5), value: isLeft) // 0.5초 간격 애니메이션
                    .onAppear {
                        repeatCount += 1
                        triggerRefreshAfterDelay()
                    } // 반복횟수 증가
                
                // 완성된 집
                Image(selectImage3())
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth * 0.2)
                    .scaleEffect(2)
                    .position(x: screenWidth * 0.8 , y: screenHeight * 0.7) // targetX, targetY값과 같도록 설정해줄 것
                    
            }
            
            // Repeat 횟수 표시(별모양
            HStack(spacing: -screenWidth * 0.02){
                ForEach(0..<repeatNumber, id: \.self){ index in
                    if index < repeatCount {
                        Image("Button_Star.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.1)
                    } else {
                        Image("Button_Star.empty")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.1)
                    }
                }
            }
            .position(x:screenWidth * 0.5, y: screenHeight * 0.06)
            
        }.onAppear {
            // TTS 읽어주기 시작.
            playTTS()
        }
        
        // 애니메이션 작동
        .onReceive(timer) { _ in
            isLeft.toggle() // 0.5초마다 좌우 위치를 변경
        }
    }
    
    // 퍼즐 맞춘 뒤 리프레시 하는 함수
        private func triggerRefreshAfterDelay() {
            DispatchQueue.main.asyncAfter(deadline: .now() + refreshTime) {
                refresh.toggle() // refresh 상태를 변경하여 뷰를 새로고침
                imgPosition = CGPoint(x: 300, y: 620) // 게임 초기화
                isSuccess = false // 게임 초기화
                print("RepeatCount: \(repeatCount)")
                if repeatCount >= repeatNumber{
                    currentStep += 1
                }
            }
        }
        
    // 현재 스텝에 따라 사운드를 재생하는 함수
    private func playTTS() {
        switch currentStep {
        case 3:
            soundManager.speakText("Pick up the straw and help build the house.")
        case 6:
            soundManager.speakText("Pick up the sticks and help build the house.")
        case 9:
            soundManager.speakText("Pick up the bricks and help build the house.")
        default:
            break
        }
    }
    
    // (Image1) 집만들기 퍼즐-외부
    private func selectImage1() -> String {
        let imageName: String
        switch currentStep {
        case 3:
            imageName = "object_home11_cut"
        case 6:
            imageName = "object_home23_cut"
        case 9:
            imageName = "object_home31_cut"
        default:
            imageName = ""
        }
        return imageName
    }
    
    // (Image2) 집만들기 퍼즐-외내부
    private func selectImage2() -> String {
        let imageName: String
        switch currentStep {
        case 3:
            imageName = "object_home11_in"
        case 6:
            imageName = "object_home23_in"
        case 9:
            imageName = "object_home31_in"
        default:
            imageName = ""
        }
        return imageName
    }

    // (Image3) 집만들기 퍼즐-완성
    private func selectImage3() -> String {
        let imageName: String
        switch currentStep {
        case 3:
            imageName = "object_home11"
        case 6:
            imageName = "object_home23"
        case 9:
            imageName = "object_home31"
        default:
            imageName = ""
        }
        return imageName
    }
}

#Preview {
    @Previewable @State var isLeft: Bool = false
    @Previewable @State var repeatNumber: Int = 2
    ThreeLittlePigs3_cam(currentStep: .constant(3), isLeft:$isLeft, repeatNumber: $repeatNumber)
}
