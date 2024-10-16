//
//  ThreeLittlePigs10.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/14/24.
//


import SwiftUI
import Vision
import AVFoundation


struct ThreeLittlePigs10: View {
    
    //By Hera
    @State private var touchPoint: CGPoint? = nil
    @State private var imgPosition: CGPoint = CGPoint(x: 300, y: 620) // 초기 이미지 위치 //x는 950으로 y는 620이 correct
    
    @Binding var currentStep: Int
    // currentStep 스토리 진행의 단계를 나타낸다
    
    @Binding var isLeft : Bool // 동그라미가 왼쪽에 있는지 여부
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect() // 0.5초 간격 타이머
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    @State private var isSuccess = false // 성공 여부를 나타내는 상태값
    
    var body: some View {
        
        ZStack{
            // 카메라 뷰
            // CameraView_ThreeLittlePig(touchPoint: $touchPoint, imgPosition: $imgPosition,currentStep:$currentStep)
            //.edgesIgnoringSafeArea(.all)
            
            makeCameraView(touchPoint: $touchPoint, imgPosition: $imgPosition).edgesIgnoringSafeArea(.all)
            //                .rotationEffect(.degrees(-90))
            
            
            // 캐릭터 위치
            HStack{
                Image("character_ThreeLittlePig1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.1) // 화면 크기 n배
                    .offset(x: -300, y: 200)
                //                    .offset(x: isLeft ? -300 : -250, y: 200) // 좌우로 이동
                //                    .animation(.easeInOut(duration: 0.8), value: isLeft) // 0.5초 간격 애니메이션
                //                    .onReceive(timer) { _ in
                //                        // 0.5초마다 좌우 위치를 변경
                //                        isLeft.toggle()
                //                    }
                
                Image("character_ThreeLittlePig2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.1) // 화면 크기 n배
                //                  .offset(x: isLeft ? -230 : -210, y: 180)
                    .offset(x: -230, y: 180)
                //                    .animation(.easeInOut(duration: 0.2), value: isLeft) // 0.5초 간격 애니메이션
                //                    .onReceive(timer) { _ in
                //                        // 0.5초마다 좌우 위치를 변경
                //                        isLeft.toggle()
                //                    }
                
                Image("character_ThreeLittlePig3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.1) // 화면 크기 n배
                //                    .offset(x: isLeft ? -200 : -170, y: 170)
                    .offset(x: -230, y: 180)
                //                    .animation(.easeInOut(duration: 0.3), value: isLeft) // 0.5초 간격 애니메이션
                //                    .onReceive(timer) { _ in
                //                        // 0.5초마다 좌우 위치를 변경
                //                        isLeft.toggle()
                //                    }
            }
            .offset(x: -200, y: 200)
            if isSuccess == false{
                Image("object_home11_cut")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.3) // 화면 크기 n배
                    .offset(x: 260, y: 100)
                
                GeometryReader { geometry in
                    Image("object_home11_in") // testimg 파일을 표시
                        .resizable()
                        .scaledToFit()
                    //.frame(width: 100, height: 100) // 이미지 크기
                        .frame(width: UIScreen.main.bounds.width * 0.1)
                    // 화면 크기 0.1배
                    // .position(x: geometry.size.width * 0.1, // 왼쪽 중앙에 배치
                    // y: geometry.size.height * 0.5)
                    
                    // 이동할 수 있도록 변경
                        .position(imgPosition)
                        .onChange(of: imgPosition) { newPosition in
                            // 목표 위치: x가 950 근방, y가 620 근방
                            let targetX: CGFloat = 950
                            let targetY: CGFloat = 620
                            
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

            }
            
            // 페이지 이동 버튼
            ButtonView_ThreeLittlePig(currentStep: $currentStep)
                .frame(width:screenWidth-80, height: screenHeight-80, alignment: .bottom)
                
                Image("object_home11")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.3)
                    .scaleEffect(2)
                // 화면 크기 n배
                    .offset(x: 260, y: 100)
            }
        }
    }

#Preview {
    @Previewable @State var isLeft: Bool = false
    ThreeLittlePigs10(currentStep: .constant(10), isLeft:$isLeft)
}
