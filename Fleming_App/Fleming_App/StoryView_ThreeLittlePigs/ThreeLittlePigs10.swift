//
//  ThreeLittlePigs10.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/14/24.
//


import SwiftUI

struct ThreeLittlePigs10: View {
    @Binding var currentStep: Int
    @Binding var isLeft : Bool // 동그라미가 왼쪽에 있는지 여부
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect() // 0.5초 간격 타이머

    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        
        ZStack{
            // 카메라 뷰
            CameraView_ThreeLittlePig(currentStep:$currentStep)
            
            // 캐릭터 위치
            HStack{
                Image("character_pig1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.1) // 화면 크기 n배
                    .offset(x: isLeft ? -300 : -250, y: 200) // 좌우로 이동
                    .animation(.easeInOut(duration: 0.8), value: isLeft) // 0.5초 간격 애니메이션
                    .onReceive(timer) { _ in
                        // 0.5초마다 좌우 위치를 변경
                        isLeft.toggle()
                    }
                
                Image("character_pig2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.1) // 화면 크기 n배
                    .offset(x: isLeft ? -230 : -210, y: 180)
                    .animation(.easeInOut(duration: 0.2), value: isLeft) // 0.5초 간격 애니메이션
                    .onReceive(timer) { _ in
                        // 0.5초마다 좌우 위치를 변경
                        isLeft.toggle()
                    }
                
                Image("character_pig3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.1) // 화면 크기 n배
                    .offset(x: isLeft ? -200 : -170, y: 170)
                    .animation(.easeInOut(duration: 0.3), value: isLeft) // 0.5초 간격 애니메이션
                    .onReceive(timer) { _ in
                        // 0.5초마다 좌우 위치를 변경
                        isLeft.toggle()
                    }
            }
            .offset(x: -250)
            
            // 각각 분리형 집
            Image("object_home11_in")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.3) // 화면 크기 n배
                .offset(x: -260, y: 100)
            
            Image("object_home11_cut")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.3) // 화면 크기 n배
                .offset(x: 260, y: 100)
                
        }
    }
}

#Preview {
    @Previewable @State var isLeft: Bool = false
    ThreeLittlePigs10(currentStep: .constant(10), isLeft:$isLeft)
}
