////
////  ThreeLittlePigs06.swift
////  Fleming_App
////
////  Created by Leo Yoon on 10/14/24.
////
//
//import SwiftUI
//
//struct ThreeLittlePigs16: View {
//    @Binding var currentStep: Int
//    @Binding var isLeft : Bool // 동그라미가 왼쪽에 있는지 여부
//    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect() // 0.5초 간격 타이머
//    
//    var screenWidth = UIScreen.main.bounds.width
//    var screenHeight = UIScreen.main.bounds.height
//    @StateObject var soundModel = SoundPlayModel()
//    @StateObject private var soundManager = SoundManager()
//
//    var body: some View {
//        
//        ZStack{
//            // 배경
//            BaseView_ThreeLittlePig(currentStep:$currentStep)
//            
//            // 그림(좌측 상단부터 입력하기)
//            Image("character_ThreeLittlePig4")
//                .resizable()
//                .scaledToFit()
//                .frame(width: UIScreen.main.bounds.width * 0.5) // 화면 크기 n배
//                .offset(x: isLeft ? -240 : -260, y: 100)
//                .animation(.easeInOut(duration: 0.5), value: isLeft) // 0.5초 간격 애니메이션
//                .onReceive(timer) { _ in
//                    // 0.5초마다 좌우 위치를 변경
//                    isLeft.toggle()
//                }
//            
//            Image("object_home31")
//                .resizable()
//                .scaledToFit()
//                .frame(width: UIScreen.main.bounds.width * 0.5) // 화면 크기 n배
//                .offset(x: isLeft ? 240 : 260, y: 100)
//                .animation(.easeInOut(duration: 0.5), value: isLeft) // 0.5초 간격 애니메이션
//                .onReceive(timer) { _ in
//                    // 0.5초마다 좌우 위치를 변경
//                    isLeft.toggle()
//                }
//            
//            // 소리 재생 버튼 추가
//            Button(action: {
//                soundModel.playSound()
//            }, label: {
//                Image(systemName: "speaker.wave.2.fill")
//                    .font(.system(size:40))
//                    .bold()
//                    .foregroundStyle(.orange)
//            })
//            .offset(x: screenWidth/2 - 60, y: -screenHeight/2 + 60)
//            
//            // 페이지 이동 버튼
//            ButtonView_ThreeLittlePig(currentStep: $currentStep)
//                .frame(width:screenWidth-100, height: screenHeight-110, alignment: .bottom)
//            
//        }
//        .onAppear{
//            soundModel.sampleMusicName = "music_sample1"
//            soundModel.playSound()
//            soundManager.speakText("""
//                The wolf came to the third house.
//            """)
//        }
//        .onDisappear(){
//            soundModel.stopSound()
//        }
//        
//    }
//}
//
//#Preview {
//    @Previewable @State var isLeft: Bool = false
//    ThreeLittlePigs16(currentStep: .constant(16), isLeft:$isLeft)
//}
