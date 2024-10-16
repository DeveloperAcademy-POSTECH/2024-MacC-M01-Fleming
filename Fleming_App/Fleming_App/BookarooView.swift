
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
    @State private var isNavigating: Bool = false
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationStack{
            ZStack {
                VStack {
                    ZStack {
                        HStack{
                            Spacer()
                            NavigationLink(destination: GuardianView()) {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.black)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.leading, 20)
                        }
                        HStack(spacing: 0) {
                            Text("Book")
                                .font(.system(size: 40, weight: .bold))
                            Text("aroo")
                                .font(.system(size: 40))
                        }
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        
                        Spacer()
                        
                    }
                    .frame(height: 50)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    Spacer()
                    ScrollView(.horizontal){
                        HStack {
                            
                            Button(action: {
                                currentStep = 1
                                isNavigating = true
                            }, label: {
                                Image("Cover_pigs")
                                    .resizable()
                                    .frame(width: 290, height: 400)
                                    .shadow(color: Color.black.opacity(0.25), radius: 20, x: 5, y: 5)
                                    .padding(.leading, 30)
                            })
                            .navigationDestination(isPresented: $isNavigating){
                                ThreeLittlePigsNavigation(currentStep: $currentStep, isLeft: $isLeft)}
                            
                            
                            Image("Cover_rsp")
                                .resizable()
                                .frame(width: 290, height: 400)
                                .shadow(color: Color.black.opacity(0.25), radius: 20, x: 5, y: 5)
                                .padding(.leading, 30)
                            Image("Cover_dots")
                                .resizable()
                                .frame(width: 290, height: 400)
                                .shadow(color: Color.black.opacity(0.25), radius: 20, x: 5, y: 5)
                                .padding(.leading, 30)
                            
                            
                            
                        }
                        .padding(50)
                    }
                    Spacer()
                }
                .frame(height: screenHeight * 0.85)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // iPad에서도 스택 네비게이션 강제
    }
}

#Preview {
    @Previewable @State var isLeft: Bool = false
    @Previewable @State var currentStep: Int = 1
    BookarooView(currentStep: $currentStep, isLeft: $isLeft)
}

