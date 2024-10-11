//
//  ThreeLittlePigs01 .swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/10/24.
//

import SwiftUI

struct NavigationToggleView: View {
    @State private var currentStep: Int = 1 // 현재 뷰 상태 관리
    @State private var isShowingNextView = false // 전환 애니메이션 상태 관리
    
    var body: some View {
        ZStack {
            
            if currentStep == 1 {
                ThreeLittlePigs01(currentStep: $currentStep, isLeft: .constant(true))
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing), // 새 뷰는 오른쪽에서 등장
                                    removal: .opacity
//                                    removal: .opacity // 기존 뷰는 흐려지면서 사라짐
                                ))
                        } else {
                            getViewForStep(currentStep: currentStep)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing), // 새 뷰는 오른쪽에서 등장
                                    removal: .opacity
//                                    removal: .move(edge: .leading) // 마지막뷰는 흐리면서 사라지게 설ㅈ
                                ))
                        }
            
            
        }
        .animation(.easeInOut(duration: 0.5), value: currentStep) // 애니메이션 추가
    }
    
    // 각 단계에 맞는 뷰를 반환
    @ViewBuilder
    func getViewForStep(currentStep: Int) -> some View {
        switch currentStep {
        case 2:
            ThreeLittlePigs02(currentStep: $currentStep)
        case 3:
            ThreeLittlePigs03(currentStep: $currentStep)
        case 4:
            ThreeLittlePigs04(currentStep: $currentStep)
        case 5:
            ThreeLittlePigs05(currentStep: $currentStep)
        default:
            EmptyView()
        }
    }
}

#Preview {
    NavigationToggleView()
}
