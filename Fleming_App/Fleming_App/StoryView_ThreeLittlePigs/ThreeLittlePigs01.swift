//
//  Untitled.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/10/24.
//

import SwiftUI

struct ThreeLittlePigs01: View {
    @Binding var currentStep: Int
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    @Binding var isLeft : Bool // 동그라미가 왼쪽에 있는지 여부
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect() // 0.5초 간격 타이머

    
    var body: some View {
        
        ZStack{
            // 배경
            BaseView_ThreeLittlePig(currentStep:$currentStep)
            
            // 제목 - 컴포넌트화 필요
            VStack{
                Text("The")
                    .font(.system(size: 128))
                    .bold()
                    .frame(width: screenWidth-80, alignment: .leading)
                    .foregroundStyle(AppColor.pigBrown)
                Text("Three")
                    .font(.system(size: 128))
                    .bold()
                    .frame(width: screenWidth-80, alignment: .leading)
                    .foregroundStyle(AppColor.pigBrown)
                Text("Little Pigs")
                    .font(.system(size: 128))
                    .bold()
                    .frame(width: screenWidth-80, alignment: .leading)
                    .foregroundStyle(AppColor.pigBrown)
            }
            .padding(.leading, 40)
            
            
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
            .offset(x: 550)
        }
    }
}

#Preview {
    @Previewable @State var isLeft: Bool = false
    ThreeLittlePigs01(currentStep: .constant(1), isLeft: $isLeft)
}
