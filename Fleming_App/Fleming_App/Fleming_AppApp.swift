//
//  Fleming_AppApp.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/7/24.
//

import SwiftUI

@main
struct Fleming_AppApp: App {
    @State private var isLeft = true // 동그라미가 왼쪽에 있는지 여부
    @State private var currentStep: Int = 0 // 현재 뷰 상태 관리 -> 0번은 PopUpView를 띄우기 위한 FakeView
    @State private var showSplash = true // 스플래쉬 뷰 표시 여부
    @State private var showAttention = false // AttentionView 표시 여부
    
    // MetalFX-framework는 실제 기기에서 사용가능할 때만 호출. (상세내용은 끝자락 주석 확인 <- *1)
    init(){ setupMetalFX() }
    
    var body: some Scene {
        
        WindowGroup {
            NavigationView {
                if showSplash {
                    SplashView()
                        .onAppear {
                            // 2초 후에 스플래쉬 뷰가 사라지도록 설정
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showSplash = false
                                    showAttention = true
                                }
                            }
                        }
                } else {
                    BookarooView(currentStep: $currentStep, isLeft: $isLeft)
                        .sheet(isPresented: $showAttention) {
                            AttentionView(showPopup: $showAttention)
                        }
                }

            }
            .navigationViewStyle(StackNavigationViewStyle()) // iPad에서도 스택 네비게이션 강제
            
//            ThreeLittlePigsNavigation(currentStep: $currentStep, isLeft: $isLeft)
            
        }
    }
}

#Preview {
    @Previewable @State var isLeft: Bool = false
        @Previewable @State var currentStep: Int = 1
        @Previewable @State var showAttention: Bool = true
        BookarooView(currentStep: $currentStep, isLeft: $isLeft)
            .sheet(isPresented: $showAttention) {
                AttentionView(showPopup: $showAttention)
            }
}

// *1. MetalFX-framework특징
// -> MetalKit은 시뮬레이터에 영향을 주지 않지만, FX는 그렇지 않음.
// -> 이렇게 하지 않으면, 시뮬레이터 사용 불가능
// ## 현재 MetalFX 사용중인 View
// -> RockPaperScissor 시리즈 이거 옆에 띄워줘
