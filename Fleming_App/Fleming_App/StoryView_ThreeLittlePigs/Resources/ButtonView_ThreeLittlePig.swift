//
//  ButtonView_ThreeLittlePig.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/16/24.
//

import SwiftUI


struct ButtonView_ThreeLittlePig: View{
    @Binding var currentStep: Int
    @StateObject private var soundManager = SoundManager()
    
    var body: some View{
        HStack(spacing: -30){
            
            // 지금 페이지의 대사를 읽어주는 버튼
            Button(action:{
                soundManager.stopSpeaking()
                
                // 소리멈춤 신호 전달시간
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                    soundManager.speakText(TextNow(currentStep: currentStep))
                }
                
            }, label: {
                Image("Button_PlaySound")

            })
            
            ZStack{
                Rectangle()
                    .foregroundStyle(.white.opacity(0.8))
                    .frame(width: screenWidth * 0.85, height: 100)
                    .cornerRadius(100)
                
                Text(TextNow(currentStep: currentStep))
                    .font(.system(size:36, weight:.bold))
            }
            
            // 마지막 페이지 제외하고 버튼 나타남.
            if (currentStep >= 18){
                Text("")
            } else {
                Button(action:{
                    if (currentStep == 18){
                        soundManager.stopSpeaking()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            currentStep = 1
                        }
                    } else{
                        
                        // Camera 사용하는 뷰에서 넘어갈 때는, 뷰전환 시간을 주기 위해, 길게 시간을 줌
                        if(currentStep == 3 || currentStep == 6 || currentStep == 9){
                            soundManager.stopSpeaking()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                currentStep = currentStep + 1 // 다음 단계로 이동
                            }
                        } else {
                            // 나머지 경우에 대해서는, 짧은 시간을 줌.
                            soundManager.stopSpeaking()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                currentStep = currentStep + 1 // 다음 단계로 이동
                            }
                        }
                    }
                },label:{
                    Image("Button_NextPage")
                })
            }
            
        }
        .offset(y: screenHeight * 0.4)
    }
    
    private func TextNow(currentStep: Int) -> String {
        switch currentStep {
        case 1:
            return "A long, long time ago, there were three little pigs."
        case 2:
            return "The first pig wanted to build a house with straw."
        case 3:
            return "Pick up the straw and help build the house."
        case 4:
            return "The first pig finished his straw house! Yay~!"
        case 5:
            return "The second pig wanted to build a house with sticks."
        case 6:
            return "Pick up the sticks and help build the house."
        case 7:
            return "The second pig finished his stick house! Yay~!"
        case 8:
            return "The third pig wanted to build a house with bricks."
        case 9:
            return "Pick up the bricks and help build the house."
        case 10:
            return "The third pig finished his brick house! Yay~!"
        case 11:
            return "One day, a wolf came to the village where the pigs lived."
        case 12:
            return "The wolf came to the first house."
        case 13:
            return "Blow with the wolf and make the straw house fly away!"
        case 14:
            return "The wolf came to the second house."
        case 15:
            return "Blow with the wolf and make the stick house fly away!"
        case 16:
            return "The wolf came to the third house."
        case 17:
            return "Blow with the wolf and try to make the brick house fly away!"
        case 18:
            return "But the brick house was very strong... \n The three little pigs could live safely!"
        default:
            return "Let's play this game!"
        }
    }
}


struct ButtonView_ThreeLittlePig_Dev: View{
    @Binding var currentStep: Int
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    @StateObject private var soundManager = SoundManager()
    
    var body: some View{
        // 뷰넘기기
        HStack(alignment: .bottom) {
            
            if (currentStep == 1){
                Text("")
            } else {
                Button(action:{
                    
                    if (currentStep == 18){
                        currentStep = 1
                    } else{
                        
                        // Camera 사용하는 뷰에서 넘어갈 때는, 뷰전환 시간을 주기 위해, 길게 시간을 줌
                        if(currentStep == 3 || currentStep == 6 || currentStep == 9){
                            soundManager.stopSpeaking()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                currentStep = currentStep - 1 // 전 단계로 이동
                            }
                        } else {
                            // 나머지는 짧게 실행
                            soundManager.stopSpeaking()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                                currentStep = currentStep + -1 // 전 단계로 이동
                            }
                        }
                        
                    }
                    
                }, label:{
                    Image(systemName: "chevron.left")
                        .font(.system(size:40))
                        .bold()
                        .foregroundStyle(.clear) // cyan이 좋아요.
                })
            }
            
            Spacer()
            
            if (currentStep >= 18){
                Circle()
                    .fill(Color.clear)
                    .frame(width:72, height: 72)
            } else {
                Button(action: {
                    
                    if (currentStep == 18){
                        currentStep = 1
                    } else{
                        
                        // Camera 사용하는 뷰에서 넘어갈 때는, 뷰전환 시간을 주기 위해, 길게 시간을 줌
                        if(currentStep == 3 || currentStep == 6 || currentStep == 9){
                            soundManager.stopSpeaking()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                currentStep = currentStep + 1 // 다음 단계로 이동
                            }
                        } else {
                            soundManager.stopSpeaking()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                currentStep = currentStep + 1 // 다음 단계로 이동
                            }
                        }
                    }
                    
                }, label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size:40))
                        .bold()
                        .foregroundStyle(.clear) // cyan이 좋아요.
                })
            }
        }
        .frame(width:screenWidth-80, height: screenHeight-80, alignment: .bottom)
    }
}
