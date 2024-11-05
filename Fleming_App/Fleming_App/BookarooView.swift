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
    
    // 언어설정(En/Ko)
    @State private var languageSelection: Bool = false // 초기 선택값 설정 (EN = false, KR = true)
    
    
    
    // 카테고리 조정을 위한 변수 (텍스트, 컬러, 너비, 높이)
    @State private var selectedCategory: String = "All" // 선택된 카테고리
    var categories = ["All", "Physic", "Concentrate", "Recognition", "Voice"]
    var categoryColor: [Color] = [Color(hex: "#F09753"),
        Color(hex: "#F8D04D"),Color(hex: "#B1D854"),
        Color(hex: "#7BBFFA"),Color(hex: "#8A81DC")
    ]
    @State private var categoryBackgroundColor: Color = Color(hex: "#F09753")
    var categoryWidth: [CGFloat] = [
        UIScreen.main.bounds.width / 24 * 3,
        UIScreen.main.bounds.width / 24 * 3,
        UIScreen.main.bounds.width / 24 * 5,
        UIScreen.main.bounds.width / 24 * 5,
        UIScreen.main.bounds.width / 24 * 3
    ]
    @State private var categoryHeight: [CGFloat] = [0, -10, -20, -30, -40]
    
    // UI사이즈 조절용 변수(반응형 구현용)
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationStack{
            ZStack {
                Rectangle()
                    .ignoresSafeArea()
                    .foregroundStyle(categoryBackgroundColor)
                    .frame(width:screenWidth, height: screenHeight)
                    .position(x: screenWidth / 2, y: screenHeight)
                
                VStack {
                    // 제목
                    HStack(spacing: 0) {
                        Text("Book")
                            .font(.system(size: 40, weight: .bold))
                        Text("aroo")
                            .font(.system(size: 40))
                        Spacer()
                        
                        // 언어전환(토글식)
                        Button(action: {
                                    languageSelection.toggle() // 버튼 클릭 시 상태 전환
                        }, label: {
                                    HStack(spacing: 8) {
                                        Text("EN")
                                            .fontWeight(languageSelection ? .regular : .bold)
                                        
                                        Text("/")
                                        
                                        Text("KR")
                                            .fontWeight(languageSelection ? .bold : .regular)
                                    }
                                    .font(.system(size:24))
                                    .foregroundColor(.black)
                                    .padding()
                                })
                        
                    }
                    .frame(maxWidth: screenWidth)
                    .multilineTextAlignment(.center)
                    .frame(height: 50)
                    .padding(.horizontal, 20)
                    .padding(.top, -20)
                    
                    Spacer()
                    
                    
                    
                    // 카테고리 (밑배경 + 표딱지)
                    
                    ZStack() {
                        
                        // 카테고리 밑배경
                        ZStack{
                            ForEach(Array(categories.enumerated()).reversed(), id: \.offset) { index, category in
                                Rectangle()
                                    .frame(width: screenWidth, height: 15)
                                    .cornerRadius(10, corners: [.topLeft, .topRight]) // 커스텀 라운드 코너
                                    .foregroundStyle(categoryColor[index])
                                    .offset(y: categoryHeight[index]) // y축 위치 설정
                            }
                            .offset(y:25)
                        }
                        
                        // 카테고리 표딱지
                        HStack(spacing: 0) {
                            HStack(spacing: 10){
                                ForEach(Array(categories.enumerated()), id: \.offset) { index, category in
                                    
                                    Button(action: {
                                        selectedCategory = category
                                        categoryBackgroundColor = getCategoryColor(for: selectedCategory)
                                        categoryHeight = getYOffset(for: selectedCategory)
                                    }, label: {
                                        Text(category)
                                            .font(.system(size:36))
                                            .fontWeight(.bold)
                                            .frame(width: categoryWidth[index], height: 55)
                                            .background(categoryColor[index])
                                            .foregroundColor(.white)
                                            .cornerRadius(30, corners: [.topLeft, .topRight]) // 커스텀 라운드 코너
                                    })
                                    .offset(y: categoryHeight[index]) // y축 위치 설정
                                }
                            }// 카테고리 ForEach 쌓기 (HStack)
                            .padding(.leading, 20)
                            Spacer()
                        }// Spacer 생성용 (HStack)
                    }// 책갈피+카테고리 쌓임 (ZStack)
                    .padding(.bottom, -10) // 카테고리와 스크롤뷰를 달라붙게 하기
                    
                    
                    // 스크롤뷰
                    ScrollView(.horizontal){
                        HStack(spacing: 72) {
                            if selectedCategory == "All" || selectedCategory == "Physic" {
                                Button(action: {
                                    currentStep = 0
                                    isNavigating = true
                                }, label: {
                                    Image("Cover_pigs")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: screenHeight * 0.55)
                                        .shadow(color: Color.black.opacity(0.25), radius: 20, x: 5, y: 5)
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
                                        .scaledToFill()
                                        .frame(height: screenHeight * 0.55)
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
                                        .scaledToFill()
                                        .frame(height: screenHeight * 0.55)
                                        .shadow(color: Color.black.opacity(0.25), radius: 20, x: 5, y: 5)
                                })
                                .navigationDestination(isPresented: $isNavigating3){
                                    StoryView_Dots()
                                    //                                      makeCameraForCircle()
                                }
                            }
                            
                            Rectangle() // (에러발생시) 빈칸 방지용
                                .frame(width: 10, height: screenHeight * 0.55)
                                .foregroundStyle(.clear)
                            
                        }
                        .padding(50)
                        
                    }
                    .background(categoryBackgroundColor)
                    .cornerRadius(10, corners: [.topLeft, .topRight]) // 커스텀 라운드 코너
                    
                    
                    Spacer()
                }
                .frame(height: screenHeight * 0.85)
            }

        }
        .navigationViewStyle(StackNavigationViewStyle()) // iPad에서도 스택 네비게이션 강제
    }
    // 선택된 카테고리에 따라 해당하는 배경 색상 선택.
    private func getCategoryColor(for category: String) -> Color {
        if let index = categories.firstIndex(of: category) {
            return categoryColor[index]
        }
        return Color.white
    }
    
    // 각 카테고리의 높이 offset(y값) 설정
    private func getYOffset(for category: String) -> [CGFloat] {
        switch category {
        case "All":
            return [0, -10, -20, -30, -40]
        case "Physic":
            return [-10, 0, -20, -30, -40]
        case "Concentrate":
            return [-10, -20, 0, -30, -40]
        case "Recognition":
            return [-10, -20, -30, 0, -40]
        case "Voice":
            return [-10, -20, -30, -40, 0]
        default:
            return [0, 0, 0, 0, 0] // 기본값
        }
    }
}

// RoundedCorner 커스텀 방법
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    @Previewable @State var isLeft: Bool = false
    @Previewable @State var currentStep: Int = 1
    BookarooView(currentStep: $currentStep, isLeft: $isLeft)
}
