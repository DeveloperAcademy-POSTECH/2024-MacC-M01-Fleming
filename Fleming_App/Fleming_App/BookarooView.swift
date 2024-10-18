//
//  BookarooView.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/9/24.
//

import SwiftUI

struct BookarooView: View{
    @Binding var currentStep: Int // 현재 뷰 상태 관리
    @Binding var isLeft : Bool // 동그라미가 왼쪽에 있는지 여부
    @State private var isNavigating: Bool = false
    @State private var isNavigating2: Bool = false
    @State private var isNavigating3: Bool = false
    @State private var selectedCategory: String = "All" // 선택된 카테고리
    
    var categories = ["All", "Physic", "Concentrate", "Voice", "Recognition"] // 카테고리 리스트
    
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
                    .padding(.horizontal, 40)
                    .padding(.top, 10)
                    Spacer()
                    
                            HStack(spacing: 20) {
                                Spacer()
                                ForEach(categories, id: \.self) { category in
                                    Text(category)
                                        .font(.system(size: selectedCategory == category ? 36 : 30, weight: .bold))
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 20)
                                        .foregroundColor(selectedCategory == category ? Color.black : Color.gray)
                                        .cornerRadius(15)
                                        .onTapGesture {
                                            selectedCategory = category
                                        }
                                }
                                Spacer()
                            }
                        .padding(.horizontal, 40)
                        .padding(.top, 10)
                    
                    
                    Spacer()
                    ScrollView(.horizontal){
                        HStack {
                            if selectedCategory == "All" || selectedCategory == "Physic" {
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
                                    ThreeLittlePigsNavigation(currentStep: $currentStep, isLeft: $isLeft)
                                }
                            }
                            
                            if selectedCategory == "All" || selectedCategory == "Concentrate" {
                                Button(action: {
                                    currentStep = 1
                                    isNavigating2 = true
                                }, label: {
                                    Image("Cover_rsp")
                                        .resizable()
                                        .frame(width: 290, height: 400)
                                        .shadow(color: Color.black.opacity(0.25), radius: 20, x: 5, y: 5)
                                        .padding(.leading, 30)
                                }).navigationDestination(isPresented: $isNavigating2){
                                    RockPaperScissorsView(currentStep: $currentStep, isNavigating2:$isNavigating2)
                                }
                            }
                            
                            if selectedCategory == "All" ||
                                selectedCategory == "Voice" ||
                                selectedCategory == "Recognition" {
                                
                                Button(action: {
                                    currentStep = 1
                                    isNavigating3 = true
                                }, label: {
                                    
                                    Image("Cover_dots")
                                        .resizable()
                                        .frame(width: 290, height: 400)
                                        .shadow(color: Color.black.opacity(0.25), radius: 20, x: 5, y: 5)
                                        .padding(.leading, 30)
                                    
                                })
                                .navigationDestination(isPresented: $isNavigating3){
//                                    RockPaperScissorsView(currentStep: $currentStep, isNavigating3:$isNavigating3)
                                }
                            }
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

//#Preview {
//    @Previewable @State var isLeft: Bool = false
//    @Previewable @State var currentStep: Int = 1
//    BookarooView(currentStep: $currentStep, isLeft: $isLeft)
//}
