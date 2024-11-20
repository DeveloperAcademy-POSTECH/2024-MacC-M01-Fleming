//
//  ThreeLittlePigs07.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/14/24.
//

import SwiftUI

struct ThreeLittlePigs7_speech: View {
    @Binding var currentStep: Int
    @Binding var isLeft : Bool // 동그라미가 왼쪽에 있는지 여부
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect() // 0.5초 간격 타이머
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    @StateObject private var soundManager = SoundManager()
    
    
    // 게이지 크기 표시를 위한 변수
    @State var rectangleWidth: CGFloat = 0 // [0, 1] 값을 0.1단위로 균일하게 증가
    @State var clickCount = 0
    
    //dBCounter 기능을 위한 변수
    @ObservedObject var audioManager = AudioManager() // 오디오 매니저 연결
    private let columns = Array(repeating: GridItem(.flexible()), count: 10) // 체크마크 열의 수를 설정(dBCounter)
    @State private var thresholdValue: Float = 55.0 // 초기 데시벨 기준 값 (언젠가는 직접반영을 구현해야 혀)
    
    //dBCounter 뷰를 위한 변수
    @State private var isPresentingSoundLevelView = false
    
    // 반복연습과 관련있는 변수들
    @State var repeatCount = 0 // 몇 회 반복?
    @Binding var repeatNumber: Int
    @State private var refresh = false
    let refreshTime: TimeInterval = 2.0 // Success를 보고, 몇 초 뒤 별이 차오르는가?
    
    var body: some View {
        
        ZStack{
            // 배경
            BaseView_ThreeLittlePig(currentStep:$currentStep)
            
            // 그림(좌측 상단부터 입력하기)
            VStack{ // 글자 + 늑대
                Text("Blow it !")
                    .font(.system(size: 128))
                    .bold()
                    .frame(alignment: .leading)
                    .foregroundStyle(AppColor.pigBrown)
                    .padding(-3)
                
                Image("character_ThreeLittlePig5")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth * 0.5) // 화면 크기 n배
                    .padding(-100)
            }
            .offset(x: -screenWidth * 0.2, y: 0)
            
            
            if repeatCount < repeatNumber {
                // 날아가기 전 집
                Image(selectImage1())
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth * 0.6) // 화면 크기 n배
                    .offset(x: screenWidth * 0.2, y: screenHeight * 0.2 - 100)
            } else if repeatCount >= repeatNumber {
                // 날아가기 이후 집
                Image(selectImage2())
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth * 0.6) // 화면 크기 n배
                    .offset(x: screenWidth * 0.2, y: screenHeight * 0.2 - 100)
            }
            
            // (게이지) - 소리가 일정량 넘으면 증가하도록
            VStack{
                
                ZStack(alignment: .leading){
                    Rectangle()
                        .foregroundStyle(Color.white)
                        .frame(width: screenWidth * 0.7, height: 40)
                        .clipShape(RoundedRectangle(cornerSize: .init(width: 30, height: 30)))
                    
                    if audioManager.dBCounter < 4{
                        Rectangle()
                            .foregroundStyle(Color.gray)
                            .frame(width: max(screenWidth * 0.7 * CGFloat(Double(audioManager.dBCounter) * 0.25) - 10, 0), height: 30) // 추가 개선 필요.
                            .clipShape(RoundedRectangle(cornerSize: .init(width: 30, height: 30)))
                            .offset(x:5)
                    }else if audioManager.dBCounter == 4{
                        
                        Rectangle()
                            .foregroundStyle(Color.gray)
                            .frame(width: max(screenWidth * 0.7 - 10, 0), height: 30) // 추가 개선 필요.
                            .clipShape(RoundedRectangle(cornerSize: .init(width: 30, height: 30)))
                            .offset(x:5)
                        Text("Sucess!!")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 36))
                            .fontWeight(.bold)
                            .offset(x:screenWidth * 0.5)
                            .onAppear{triggerRefreshAfterDelay()}
                        
                    } else if audioManager.dBCounter > 4 {
                        Text("Sucess!!")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 36))
                            .fontWeight(.bold)
                            .offset(x:screenWidth * 0.5)
                            .onAppear {
                                triggerRefreshAfterDelay()
                                if(repeatCount >= repeatNumber){
                                    currentStep = currentStep + 1
                                }
                            }
                    }
                }
            }
            .offset(y: -screenHeight * 0.44) // -screenHeight / 2 + screenHeight * 0.06
            .frame(width: screenWidth * 0.70, alignment: .center)
            
        }
        .onAppear {
            // TTS 읽어주기 시작.
            playTTS()
        }

        .fullScreenCover(isPresented: $isPresentingSoundLevelView){
            SoundLevelView()
        }
    }
    
    // Success 이후, 넘어가기
    private func triggerRefreshAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + refreshTime) {
            repeatCount += 1
            print("RepeatCount: \(repeatCount)")

            if repeatCount >= repeatNumber{
                currentStep += 1
            } else {
                refresh.toggle() // refresh 상태를 변경하여 뷰를 새로고침
                audioManager.resetDBCounter() // 게임 초기화
            }
        }
    }
    
    // 현재 스텝에 따라 사운드를 재생하는 함수
    private func playTTS() {
        switch currentStep {
        case 13:
            soundManager.speakText("Blow with the wolf and make the straw house fly away!")
        case 15:
            soundManager.speakText("Blow with the wolf and make the stick house fly away!")
        case 17:
            soundManager.speakText("Blow with the wolf and try to make the brick house fly away!")
        default:
            break
        }
    }
    
    // (Image1) 날아가기 전 집
    private func selectImage1() -> String {
        let imageName: String
        switch currentStep {
        case 13:
            imageName = "object_home11"
        case 15:
            imageName = "object_home21"
        case 17:
            imageName = "object_home31"
        default:
            imageName = ""
        }
        return imageName
    }
    
    // (Image2) 날아가기 이후 집
    private func selectImage2() -> String {
        let imageName: String
        switch currentStep {
        case 13:
            imageName = "object_home12"
        case 15:
            imageName = "object_home22"
        case 17:
            imageName = "object_home32"
        default:
            imageName = ""
        }
        return imageName
    }
    
}

#Preview {
    @Previewable @State var isLeft: Bool = false
    @Previewable @State var repeatNumber: Int = 2
    ThreeLittlePigs7_speech(currentStep: .constant(15), isLeft:$isLeft, repeatNumber: $repeatNumber)
}
