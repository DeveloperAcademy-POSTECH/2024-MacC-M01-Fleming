//
//  FableView.swift
//  BoBuSang_Trial
//
//  Created by Leo Yoon on 10/7/24.
//

import SwiftUI

struct FableView: View{
//    @ObservedObject var viewModel = MonitorSoundViewModel() //필요없지 않나?
    @ObservedObject var cameraViewModel = CameraViewModel()
    @Binding var isLeft : Bool // 동그라미가 왼쪽에 있는지 여부
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect() // 0.5초 간격 타이머
    @State public var screenWidth = UIScreen.main.bounds.width
    @State public var screenHeight = UIScreen.main.bounds.height
        
    var body: some View{
        ZStack{
            CameraView(viewModel: cameraViewModel)
                .rotationEffect(.degrees(-90)) // 왼쪽으로 90도 회전
                .scaledToFit()
                .frame(width:screenWidth)
                .position(x: screenWidth/2, y: screenHeight/2)
                .edgesIgnoringSafeArea(.all) // 사이즈 맞춤
            
            Color.white // 흰색 배경
                        .opacity(0.4) // 불투명도 40% 적용
                        .edgesIgnoringSafeArea(.all) // 모든 영역을 꽉 채움
            
            Image("iPad mini 8.3 - _pig_background_cut")
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth) // 가로 기준으로 늘림
            
            HStack{
                Image("character_pig1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.1) // 원래 크기의 0.75배로 설정
                    .offset(x: isLeft ? -300 : -250, y: 200) // 좌우로 이동
                    .animation(.easeInOut(duration: 0.8), value: isLeft) // 0.5초 간격 애니메이션
                    .onReceive(timer) { _ in
                        // 0.5초마다 좌우 위치를 변경
                        isLeft.toggle()
                    }
                
                Image("character_pig2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.1) // 화면 크기의 0.3배로 설정
                    .offset(x: isLeft ? -230 : -210, y: 180) // 좌우로 이동
                    .animation(.easeInOut(duration: 0.2), value: isLeft) // 0.5초 간격 애니메이션
                    .onReceive(timer) { _ in
                        // 0.5초마다 좌우 위치를 변경
                        isLeft.toggle()
                    }
                
                Image("character_pig3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.1) // 원래 크기의 0.75배로 설정
                    .offset(x: isLeft ? -200 : -170, y: 170) // 좌우로 이동
                    .animation(.easeInOut(duration: 0.3), value: isLeft) // 0.5초 간격 애니메이션
                    .onReceive(timer) { _ in
                        // 0.5초마다 좌우 위치를 변경
                        isLeft.toggle()
                    }
                
            }
        }
        .frame(width: screenWidth, height: UIScreen.main.bounds.height)
    }

}

#Preview{
    @Previewable @State var isLeft: Bool = false
    FableView(isLeft: $isLeft)
}
