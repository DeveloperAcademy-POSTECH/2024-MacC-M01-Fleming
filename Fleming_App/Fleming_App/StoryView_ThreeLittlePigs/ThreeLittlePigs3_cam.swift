
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
    
    // 위치 지정용 변수
    @State private var touchPoint: CGPoint? = nil
    @State private var imgPosition: CGPoint = CGPoint(x: 300, y: 620) // 초기 이미지 위치 //x는 950으로 y는 620이 correct
    
    @Binding var currentStep: Int // currentStep 스토리 진행의 단계
    
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
    let refreshTime: TimeInterval = 2.0 // Success를 보고, 몇 초 뒤 별이 차오르는가?
    
    var body: some View {
        
        ZStack{
            
            // 카메라 뷰(배경깔기)
            makeCameraView(touchPoint: $touchPoint, imgPosition: $imgPosition).edgesIgnoringSafeArea(.all)
            
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
                    .offset(x: screenWidth * 0.3, y: screenHeight * 0.1) // 초기 테스트값은 x:950, y:620
                
                GeometryReader { geometry in
                    Image(selectImage2()) // testimg 파일을 표시
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.4)
                    
                    // 이동할 수 있도록 변경
                        .position(imgPosition)
                        .onChange(of: imgPosition) { newPosition in
                            let targetX: CGFloat = screenWidth * 0.8 // let targetX: CGFloat = 950 // 초기 테스트값
                            let targetY: CGFloat = screenHeight * 0.6 // let targetY: CGFloat = 620 // 초기 테스트값
                            
                            // 변경된 위치가 목표 위치와 가까워지면 isSuccess를 true
                            if abs(newPosition.x - targetX) < 50 && abs(newPosition.y - targetY) < 50 {
                                withAnimation {
                                    isSuccess = true
                                }
                            }
                        }
                }
            }
            
            // 손가락이 맞닿았을 때 원 그리기
            if let touchPoint = touchPoint {
                Circle()
                    .fill(Color.red)
                    .frame(width: 30, height: 30)
                    .position(touchPoint)
            }
            
            // 성공 메시지 표시
            if isSuccess {
                Text("Success!")
                    .font(.title)
                    .foregroundColor(.red)
                    .bold()
                    .position(x: screenWidth / 2, y: screenHeight / 2)
                    .animation(.easeInOut(duration: 3), value: isSuccess)
                    .onAppear {
                        repeatCount += 1
                        triggerRefreshAfterDelay()
                    } // 반복횟수 증가
                
                // 완성된 집
                Image(selectImage3())
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth * 0.3)
                    .scaleEffect(2)
                    .offset(x: 260, y: 100)
            }
            
            // 페이지 이동 버튼
            ButtonView_ThreeLittlePig(currentStep: $currentStep)
                .frame(width:screenWidth-100, height: screenHeight-110, alignment: .bottom)
            
        }.onAppear {
            // TTS 읽어주기 시작.
            playTTS()
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
            imageName = "object_home21"
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