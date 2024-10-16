//
//  BookarooView.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/15/24.
//

import SwiftUI

struct BookarooView: View{
    @Binding var currentStep: Int // 현재 뷰 상태 관리
    @Binding var isLeft : Bool // 동그라미가 왼쪽에 있는지 여부
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var body: some View{
        
        VStack{
            Text("Hi Leo")
                .font(.system(size: 128))
                .bold()
                .frame(width: screenWidth-80, alignment: .leading)
                .foregroundStyle(AppColor.pigBrown)
            
            Spacer()
            
            ScrollView(.horizontal){
                LazyHStack(spacing: 60) {
                    // 네비게이션 한 개
                    
                    NavigationLink(destination: ThreeLittlePigsNavigation(currentStep: $currentStep, isLeft:$isLeft)){
                        Image("Cover_pig")
                            .resizable()
                            .frame(width: 0.23 * screenWidth, height: 0.50 * screenHeight)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 32))
                            .contentShape(Rectangle())
                    }
                    
                    // 뒤에 추가하는 것들... 컨텐츠에 따라 컴포넌트화 할 예정...
                    ForEach(0..<10) { index in
                        VStack(alignment:.leading) {
                            Button(action: {
                                print("\(index+1)번 동화 클릭")
                            },label:{Rectangle()
                                    .fill(Color.gray)
                                    .frame(width: 0.23 * screenWidth, height: 0.50 * screenHeight)
                                    .overlay(
                                        Text("\(index+1)번 동화")
                                            .font(.title)
                                            .foregroundStyle(.white)
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 32))
                            })
                        } //
                    } // ForEach 끝
                }
            }
            .padding(.horizontal, 5)
            .padding(.top, -40)
            
            Spacer()
        }
        .frame(height: screenHeight * 0.85)
    }
}
