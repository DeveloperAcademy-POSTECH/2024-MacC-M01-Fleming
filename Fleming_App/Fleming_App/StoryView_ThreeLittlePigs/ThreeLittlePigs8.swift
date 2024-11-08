//
//  ThreeLittlePigs06.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/14/24.
//

import SwiftUI

struct ThreeLittlePigs8: View {
    @Binding var currentStep: Int
    @Binding var isLeft : Bool // 동그라미가 왼쪽에 있는지 여부
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect() // 0.5초 간격 타이머
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    @StateObject var soundModel = SoundPlayModel()
    @StateObject private var soundManager = SoundManager()

    var body: some View {
        
        ZStack{
            // 배경
            BaseView_ThreeLittlePig(currentStep:$currentStep)
            
            // 그림(좌측 상단부터 입력하기)
            
            Image("object_home31")
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth * 0.6) // 화면 크기 n배
                .offset(x: 0, y: screenHeight / 10)
            
            Image("character_ThreeLittlePig1")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.3) // 화면 크기 n배
                .offset(x: -screenWidth / 4, y: isLeft ? screenHeight / 5 : screenHeight / 5 + 20)
                .animation(.easeInOut(duration: 0.5), value: isLeft) // 0.5초 간격 애니메이션
                .onReceive(timer) { _ in
                    // 0.5초마다 좌우 위치를 변경
                    isLeft.toggle()
                }
            
            Image("character_ThreeLittlePig2")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.3) // 화면 크기 n배
                .offset(x: 0, y: isLeft ? screenHeight / 4 : screenHeight / 4 - 20)
                .animation(.easeInOut(duration: 0.5), value: isLeft) // 0.5초 간격 애니메이션
                .onReceive(timer) { _ in
                    // 0.5초마다 좌우 위치를 변경
                    isLeft.toggle()
                }
            
            Image("character_ThreeLittlePig3")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.3) // 화면 크기 n배
                .offset(x: screenWidth / 4, y: isLeft ? screenHeight / 5 : screenHeight / 5 + 20)
                .animation(.easeInOut(duration: 0.5), value: isLeft) // 0.5초 간격 애니메이션
                .onReceive(timer) { _ in
                    // 0.5초마다 좌우 위치를 변경
                    isLeft.toggle()
                }
            
        }
        .onAppear{
            soundModel.stopSound()
            soundModel.playSound()
            soundManager.speakText("""
                But the brick house was very strong... The three little pigs could live safely!
            """)
        }
        .onDisappear(){
            soundModel.stopSound()
        }
    }
}

#Preview {
    @Previewable @State var isLeft: Bool = false
    ThreeLittlePigs8(currentStep: .constant(18), isLeft:$isLeft)
}
