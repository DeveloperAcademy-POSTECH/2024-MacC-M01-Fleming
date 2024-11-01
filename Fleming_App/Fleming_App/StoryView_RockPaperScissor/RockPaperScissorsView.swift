//
//  RockPaperScissorsView.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/18/24.
//
// 영어식으로 하면, Rock Paper Scissors가 익숙하다고 합니다 ㅎㅎ

import SwiftUI

struct RockPaperScissorsView: View{
    @Binding var currentStep: Int
    @Binding var isNavigating2: Bool
    
    // Popup과 연결되는 값들(Repeat 횟수)
    @State private var isPresented: Bool = true
    @State private var repeatNumber: Int = 1 // 반복횟수 저장
    // -> (추후)SwiftData와 결합 필요.
    
    var body: some View {
        ZStack {
            
            // 뷰 이동방법
            if currentStep == 0 {
                RockPaperScissors1(currentStep: $currentStep)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing), // 새 뷰는 오른쪽에서 등장
                        removal: .opacity))
                
                PopupView(isPresented: $isPresented, repeatNumber: $repeatNumber)
                    .onChange(of: isPresented){ currentStep = 1 }
                
            } else {
                getViewForStep(currentStep: currentStep)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing), // 새 뷰는 오른쪽에서 등장
                        removal: .opacity))
            }
            
        }
        .animation(.easeInOut(duration: 0.5), value: currentStep) // 애니메이션 추가
    }
    
    @ViewBuilder
    func getViewForStep(currentStep: Int) -> some View {
        switch currentStep {
        case 1:
            RockPaperScissors1(currentStep: $currentStep)
        case 2:
            RockPaperScissors2(currentStep: $currentStep, repeatNumber: $repeatNumber)
        case 3:
            RockPaperScissors3(currentStep: $currentStep)
        default:
            EmptyView()
        }
    }
}

#Preview{
    @Previewable @State var currentStep: Int = 1
    RockPaperScissors1(currentStep: $currentStep)
}

// *1. MetalFX-framework특징
// -> MetalKit은 시뮬레이터에 영향을 주지 않지만, FX는 그렇지 않음.
// -> 이렇게 하지 않으면, 시뮬레이터 사용 불가능
// ## 현재 MetalFX 사용중인 View
// -> RockPaperScissor 시리즈 이거 옆에 띄워줘
