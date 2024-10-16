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
            
            // 게이지
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
                        .frame(width: screenWidth*0.7, height: 60)
                        .clipShape(RoundedRectangle(cornerSize: .init(width: 30, height: 30)))
                    Rectangle()
                        .foregroundStyle(Color.gray)
                        .frame(width: screenWidth*0.6, height: 50)
                        .clipShape(RoundedRectangle(cornerSize: .init(width: 30, height: 30)))
                        .offset(x:5)
                }
            }
            .offset(y: screenHeight * 0.4)
            .frame(width: screenWidth * 0.70, alignment: .center)
        }
    }
}

#Preview {
    @Previewable @State var isLeft: Bool = false
    ThreeLittlePigs09(currentStep: .constant(9), isLeft: $isLeft)
}
