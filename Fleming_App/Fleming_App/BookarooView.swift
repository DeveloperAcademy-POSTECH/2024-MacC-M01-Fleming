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
    
    // 카테고리 조정을 위한 변수 (텍스트, 컬러, 너비, 높이)
    @State private var selectedCategory: String = "All" // 선택된 카테고리
    
    var categories = ["All", "Physic", "Concentrate", "Recognition", "Voice", " "] // 변수 수정시, 카테고리에서도 수정 바람.
    
    var categoryColor: [Color] = [Color(hex: "#F09753"),Color(hex: "#F8D04D"),Color(hex: "#B1D854"),
                                  Color(hex: "#7BBFFA"),Color(hex: "#8A81DC"), Color(hex: "#49CFB0")]
    @State private var categoryBackgroundColor: Color = Color(hex: "#F09753")
    var categoryWidth: [CGFloat] = [
        UIScreen.main.bounds.width / 25 * 3, UIScreen.main.bounds.width / 25 * 3,
        UIScreen.main.bounds.width / 25 * 5, UIScreen.main.bounds.width / 25 * 5,
        UIScreen.main.bounds.width / 25 * 3, UIScreen.main.bounds.width / 25 * 3
    ]
    let categoryInterval: CGFloat = UIScreen.main.bounds.width / 250
    @State private var categoryHeight: [CGFloat] = [0, -10, -20, -30, -40, -50]
    
    // UI사이즈 조절용 변수(반응형 구현용)
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    
    // 설정탭 관련 변수(기본, 언어)
    @State private var isSettingView: Bool = false // Setting뷰일때, 스크롤뷰 잠금
//    @State private var languageSetting: Bool = false // false: 영어, true: 한국어
    
    // 설정탭 관련 변수 (사운드)
//    @State private var volumeBackgroundIndex = 0
//    @State private var volumeTTSIndex = 0
//    let sliderValues: [Double] = [0, 0.25, 0.5, 0.75, 1]
//    var volumeBackground: Double { sliderValues[volumeBackgroundIndex] }
//    var volumeTTS: Double { sliderValues[volumeTTSIndex] }
    

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
                        
                    }
                    .frame(maxWidth: screenWidth)
                    .multilineTextAlignment(.center)
                    .frame(height: 50)
                    .padding(.horizontal, 20)
                    .padding(.top, -40)
                    .padding(.bottom, 10)
                    
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
                            Spacer().frame(width: categoryInterval * 2) // 기본 간격
                            
                            HStack(spacing: categoryInterval){
                                ForEach(Array(categories.enumerated()), id: \.offset) { index, category in
                                    
                                    Button(action: {
                                        selectedCategory = category // 선택된 표딱지 선정
                                        categoryBackgroundColor = getCategoryColor(for: selectedCategory) // 표딱지 색위치 변화
                                        categoryHeight = getYOffset(for: selectedCategory) // 표딱지 높이 변화
                                        isSettingView = (selectedCategory == " ") // Setting뷰일때, 스크롤뷰 잠금
                                        
                                    }, label: {
                                        // 설정아이콘
                                        if index == (categories.count - 1){
                                            Image(systemName:"gearshape.fill")
                                                .font(.system(size: 40))
                                                .foregroundStyle(.white)
                                                .frame(width: categoryWidth[index], height: 55, alignment: .bottom)
                                                .background(categoryColor[index])
                                                .cornerRadius(30, corners: [.topLeft, .topRight]) // 커스텀 라운드 코너
                                        } else {
                                            // 설정 외 아이콘
                                            Text(category)
                                                .font(.system(size:36, weight: .bold))
                                                .foregroundColor(.white)
                                                .frame(width: categoryWidth[index], height: 55, alignment: .bottom)
                                                .background(categoryColor[index])
                                                .cornerRadius(30, corners: [.topLeft, .topRight]) // 커스텀 라운드 코너
                                        }
                                    })
                                    .offset(y: categoryHeight[index]) // y축 위치 설정
                                    
                                    // Spacer를 활용하여 마지막 요소에만 다른 간격을 설정
                                    if index == (categories.count - 2) {
                                        Spacer() // 마지막 요소에 다른 간격
                                    } else {
                                        Spacer().frame(width: categoryInterval) // 기본 간격
                                    }
                                }
                            }// 카테고리 ForEach 쌓기 (HStack)
                        }// Spacer 생성용 (HStack)
                    }// 책갈피+카테고리 쌓임 (ZStack)
                    .padding(.bottom, -10) // 카테고리와 스크롤뷰를 달라붙게 하기
                    
                    // 스크롤뷰(설정칸 제외)
                    ScrollView(.horizontal, showsIndicators: false){
                        Spacer()
                        
                        HStack(spacing: 72) {
                            if selectedCategory == "All" || selectedCategory == "Physic" {
                                Button(action: {
                                    currentStep = 0
                                    isNavigating = true
                                }, label: {
                                    Image("Cover_pig")
                                        .resizable()
                                        .scaledToFit()
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
                                        .scaledToFit()
                                        .frame(height: screenHeight * 0.55)
                                        .shadow(color: Color.black.opacity(0.25), radius: 20, x: 5, y: 5)
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
                                        .scaledToFit()
                                        .frame(height: screenHeight * 0.55)
                                        .shadow(color: Color.black.opacity(0.25), radius: 20, x: 5, y: 5)
                                })
                                .navigationDestination(isPresented: $isNavigating3){
                                    //StoryView_Dots()
                                    
                                    //DotsFirstView()
                                    RandomCircle() //초기 view 테스트 위해 임시 주석처리

                                }
                            }
                            
                            
                            // 스크롤뷰(설정칸 - 스크롤 안되게 해둠)
                            if selectedCategory == " "{
//                                VStack{
//                                    // (임시표시) Sound
//                                    HStack{
//                                        Spacer().frame(width: screenWidth * 0.025)
//                                        Text("SOUND")
//                                            .font(.system(size:48, weight:.bold))
//                                            .foregroundStyle(.white)
//                                            .frame(width: 300, alignment: .leading)
//                                        Spacer()
//                                    }
//                                    
//                                    // (임시표시) Sound-detail
//                                    VStack(){
//                                        HStack(spacing: 40){
//                                            Text("Background")
//                                                .font(.system(size:40, weight:.bold))
//                                                .foregroundStyle(.white)
//                                                .frame(width:320, alignment:.leading)
//                                            
//                                            Image("Button_PlaySound2")
//                                                .resizable()
//                                                .scaledToFit()
//                                                .frame(width:48)
//                                            
//                                            Slider(
//                                                value: Binding(
//                                                    get: { Double(volumeBackgroundIndex) },
//                                                    set: { newValue in
//                                                        volumeBackgroundIndex = Int(round(newValue))
//                                                    }
//                                                ),
//                                                in: 0...4,
//                                                step: 1
//                                            )
//                                            .accentColor(.white)
//                                            .frame(width: screenWidth * 0.3)
//                                        }
//                                        
//                                        HStack(spacing:40){
//                                            Text("Text Sound")
//                                                .font(.system(size:40, weight:.bold))
//                                                .foregroundStyle(.white)
//                                                .frame(width:320, alignment: .leading)
//                                            
//                                            Image("Button_PlaySound2")
//                                                .resizable()
//                                                .scaledToFit()
//                                                .frame(width:48)
//                                            
//                                            Slider(
//                                                value: Binding(
//                                                    get: { Double(volumeTTSIndex) },
//                                                    set: { newValue in
//                                                        volumeTTSIndex = Int(round(newValue))
//                                                    }
//                                                ),
//                                                in: 0...4,
//                                                step: 1
//                                            )
//                                            .accentColor(.white)
//                                            .frame(width: screenWidth * 0.3)
//                                        }
//                                    }
//                                    
//                                    // (임시표시)Language
//                                    HStack{
//                                        Spacer().frame(width: screenWidth * 0.025)
//                                        
//                                        Text("Language")
//                                            .font(.system(size:48, weight:.bold))
//                                            .foregroundStyle(.white)
//                                            .frame(width: 300, alignment: .leading)
//                                        
//                                        Spacer()
//                                        
//                                        Button(action:{
//                                            languageSetting = true
//                                        }, label:{
//                                            
//                                            if languageSetting == true {
//                                                Text("Korean")
//                                                    .font(.system(size:48, weight:.bold))
//                                                    .foregroundStyle(.white)
//                                                    .padding(10)
//                                            } else {
//                                                Text("Korean")
//                                                    .font(.system(size:48, weight:.bold))
//                                                    .foregroundStyle(.white)
//                                                    .padding(10)
//                                                    .opacity(0.4)
//                                            }
//                                        })
//                                        
//                                        Spacer().frame(width: screenWidth * 0.05)
//                                        
//                                        Button(action:{
//                                            languageSetting = false
//                                        }, label:{
//                                            if languageSetting == false {
//                                                Text("English")
//                                                    .font(.system(size:48, weight:.bold))
//                                                    .foregroundStyle(.white)
//                                                    .padding(10)
//                                            } else {
//                                                Text("English")
//                                                    .font(.system(size:48, weight:.bold))
//                                                    .foregroundStyle(.white)
//                                                    .padding(10)
//                                                    .opacity(0.4)
//                                            }
//                                        })
//                                        Spacer()
//                                    }
//                                    
//                                    Spacer()
//                                }
//                                .frame(width:screenWidth, height: screenHeight * 0.55)
                                
                                SettingView()
                                    .frame(width:screenWidth, height: screenHeight * 0.55)                                
                            }
                            
                        }
                        .padding(50)
                        
                    }
                    .background(categoryBackgroundColor)
                    .cornerRadius(10, corners: [.topLeft, .topRight]) // 커스텀 라운드 코너
                    .scrollDisabled(isSettingView) // Setting뷰일때, 스크롤뷰 잠금
                    
                    Spacer()
                    
                    // 안내 문구 (1미터 떨어져서 하세용이라는 뜻)
                    HStack{
                        Image(systemName: "circle.fill")
                            .font(.system(size: 10, weight: .bold))
                        Text("Enjoy activities best from 1m away")
                            .font(.system(size: 40, weight: .bold))
                    }
                    .foregroundStyle(.white.opacity(0.6))
                    
                    Spacer()
                } // VStack 끝
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
            return [0, -10, -20, -30, -40, -50]
        case "Physic":
            return [-10, 0, -20, -30, -40, -50]
        case "Concentrate":
            return [-10, -20, 0, -30, -40, -50]
        case "Recognition":
            return [-10, -20, -30, 0, -40, -50]
        case "Voice":
            return [-10, -20, -30, -40, 0, -50]
        case " ":
            return [-10, -20, -30, -40, -50, 0]
        default:
            return [0, 0, 0, 0, 0, 0] // 기본값
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
