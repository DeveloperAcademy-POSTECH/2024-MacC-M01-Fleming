////
////  ThreeLittlePigs05.swift
////  Fleming_App
////
////  Created by Leo Yoon on 10/10/24.
////
//
//import SwiftUI
//
//struct ThreeLittlePigs10: View {
//    //By Hera
//    @State private var touchPoint: CGPoint? = nil
//    @State private var imgPosition: CGPoint = CGPoint(x: 300, y: 620) // 초기 이미지 위치 //x는 950으로 y는 620이 correct
//    
//    @Binding var currentStep: Int
//    @Binding var isLeft : Bool // 동그라미가 왼쪽에 있는지 여부
//    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect() // 0.5초 간격 타이머
//    
//    var screenWidth = UIScreen.main.bounds.width
//    var screenHeight = UIScreen.main.bounds.height
//    @StateObject private var soundManager = SoundManager()
//    
//    var body: some View {
//        
//        ZStack{
//
//            BaseView_ThreeLittlePig(currentStep:$currentStep)
//            
//            Image("character_ThreeLittlePig3")
//                .resizable()
//                .scaledToFit()
//                .frame(width: UIScreen.main.bounds.width * 0.3) // 화면 크기 n배
//                .offset(x:  -screenWidth*0.15, y: isLeft ? screenHeight*0.08 : screenHeight*0.16)
//                .animation(.easeInOut(duration: 0.3), value: isLeft)
//                .onReceive(timer) { _ in
//                    // 0.5초마다 좌우 위치를 변경
//                    isLeft.toggle()
//                }
//            
//            Image("object_home31")
//                .resizable()
//                .scaledToFit()
//                .frame(width: UIScreen.main.bounds.width * 0.5) // 화면 크기 n배
//            //                .offset(x: isLeft ? 240 : 260, y: screenHeight*0.07)
//                .offset(x: isLeft ? 240 : 260, y: screenHeight*0.07)
//                .animation(.easeInOut(duration: 0.5), value: isLeft) // 0.5초 간격 애니메이션
//                .onReceive(timer) { _ in
//                    // 0.5초마다 좌우 위치를 변경
//                    isLeft.toggle()
//                }
//            
//            // 페이지 이동 버튼
//            ButtonView_ThreeLittlePig(currentStep: $currentStep)
//                .frame(width:screenWidth-100, height: screenHeight-110, alignment: .bottom)
//            
//        }.onAppear(){
//            soundManager.speakText("""
//                    The third pig finished his brick house! Yay~!
//            """)
//        }
//        .onDisappear(){
//            soundManager.stopSpeaking()
//        }
//        
//    }
//}
//
//#Preview {
//    @Previewable @State var isLeft: Bool = false
//    ThreeLittlePigs10(currentStep: .constant(10), isLeft:$isLeft)
//}
