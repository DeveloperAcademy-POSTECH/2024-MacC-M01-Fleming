//
//  ThreeLittlePigs09.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/14/24.
//

import SwiftUI

struct ThreeLittlePigs09: View {
    @Binding var currentStep: Int
    @Binding var isLeft : Bool // 동그라미가 왼쪽에 있는지 여부
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect() // 0.5초 간격 타이머
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    // 게이지 크기 표시를 위한 변수
    @State var rectangleWidth: CGFloat = 0 // [0, 1] 값을 0.1단위로 균일하게 증가
    @State var clickCount = 0
    
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
                    .frame(width: UIScreen.main.bounds.width * 0.5) // 화면 크기 n배
                    .padding(-100)
            }
            .offset(x: -260, y: -50)
            
            Image("object_home22")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.6) // 화면 크기 n배
                .offset(x: 260, y: 0)
            
//            // 게이지
//            VStack{
//                Text("Scream")
//                    .font(.system(size: 36))
//                    .bold()
//                    .frame(alignment: .leading)
//                    .foregroundStyle(AppColor.pigBrown)
//                    .padding(-3)
//                
//                ZStack(alignment: .leading){
//                    Rectangle()
//                        .foregroundStyle(Color.white)
//                        .frame(width: screenWidth*0.7, height: 60)
//                        .clipShape(RoundedRectangle(cornerSize: .init(width: 30, height: 30)))
//                    Rectangle()
//                        .foregroundStyle(Color.gray)
//                        .frame(width: screenWidth*0.6, height: 50)
//                        .clipShape(RoundedRectangle(cornerSize: .init(width: 30, height: 30)))
//                        .offset(x:5)
//                }
//            }
//            .offset(y: screenHeight * 0.4)
//            .frame(width: screenWidth * 0.70, alignment: .center)
            
            // 임시1(게이지) - 눌러서 1씩 증가하도록
            VStack{
                Text("Scream")
                    .font(.system(size: 36))
                    .bold()
                    .frame(alignment: .leading)
                    .foregroundStyle(AppColor.pigBrown)
                    .padding(-3)

                ZStack(alignment: .leading){
                    Rectangle()
                        .foregroundStyle(Color.white)
                        .frame(width: screenWidth * 0.7, height: 60)
                        .clipShape(RoundedRectangle(cornerSize: .init(width: 30, height: 30)))
                    Rectangle()
                        .foregroundStyle(Color.gray)
                        .frame(width: max(screenWidth * 0.7 * rectangleWidth - 10, 0), height: 50)
                        .clipShape(RoundedRectangle(cornerSize: .init(width: 30, height: 30)))
                        .offset(x:5)
                }
            }
            .offset(y: screenHeight * 0.4)
            .frame(width: screenWidth * 0.70, alignment: .center)
            
            // 임시1(버튼) - 눌러서 1씩 증가하도록
            Button(action: {
                if clickCount < 10 {
                    clickCount += 1
                    rectangleWidth = 0 + CGFloat(clickCount) * 0.1 // 클릭할 때마다 길이를 10씩 증가
                    print("Increase Width")
                } else if clickCount == 10 {
                    currentStep = currentStep + 1
                }
            }, label: {
                Image(systemName: "microphone.circle")
                    .font(.system(size:40))
                    .bold()
                    .foregroundStyle(.orange)
            })
            .offset(x: screenWidth/2 - 60, y: -screenHeight/2 + 60)
            
            // 페이지 이동 버튼
            ButtonView_ThreeLittlePig(currentStep: $currentStep)
                .frame(width:screenWidth-80, height: screenHeight-80, alignment: .bottom)
            
        }
    }
}

#Preview {
    @Previewable @State var isLeft: Bool = false
    ThreeLittlePigs09(currentStep: .constant(9), isLeft: $isLeft)
}
