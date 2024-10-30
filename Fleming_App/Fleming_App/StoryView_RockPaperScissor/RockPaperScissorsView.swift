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
    
    var body: some View {
        ZStack {
            
            // 뷰 이동방법
            if currentStep == 1 {
                RockPaperScissors1(currentStep: $currentStep)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing), // 새 뷰는 오른쪽에서 등장
                        removal: .opacity))
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
        case 2:
            RockPaperScissors2(currentStep: $currentStep)
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
