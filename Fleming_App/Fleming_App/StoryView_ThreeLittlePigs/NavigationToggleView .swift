//
//  ThreeLittlePigsNavigation.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/10/24.
//

import SwiftUI

struct ThreeLittlePigsNavigation: View {
    @Binding var currentStep: Int // 현재 뷰 상태 관리
    @State private var isShowingNextView = false // 전환 애니메이션 상태 관리
    @Binding var isLeft : Bool // 동그라미가 왼쪽에 있는지 여부
    
    var body: some View {
        ZStack {
            
            // 뷰 이동방법
            if currentStep == 1 {
                ThreeLittlePigs01(currentStep: $currentStep, isLeft: .constant(true))
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
        //        .navigationBarBackButtonHidden(true) // 추후에 커스텀함
    }
    
    // 각 단계에 맞는 뷰를 반환
    @ViewBuilder
    func getViewForStep(currentStep: Int) -> some View {
        switch currentStep {
        case 2:
            ThreeLittlePigs02(currentStep: $currentStep, isLeft: $isLeft)
        case 3:
            ThreeLittlePigs02_A(currentStep: $currentStep, isLeft: $isLeft)
        case 4:
            ThreeLittlePigs03(currentStep: $currentStep, isLeft: $isLeft)
        case 5:
            ThreeLittlePigs05(currentStep: $currentStep, isLeft: $isLeft)
        case 6:
            ThreeLittlePigs06(currentStep: $currentStep, isLeft: $isLeft)
        case 7:
            ThreeLittlePigs07(currentStep: $currentStep, isLeft: $isLeft)
        case 8:
            ThreeLittlePigs08(currentStep: $currentStep, isLeft: $isLeft)
        case 9:
            ThreeLittlePigs09(currentStep: $currentStep, isLeft: $isLeft)
        case 10:
            ThreeLittlePigs10(currentStep: $currentStep, isLeft: $isLeft)
//        case 11:
//        case 12:
//        case 13:
//        case 14:
//        case 15:
//        case 16:
//        case 17:
//        case 18:
        default:
            EmptyView()
        }
    }
}

#Preview {
    @Previewable @State var isLeft: Bool = false
    @Previewable @State var currentStep: Int = 1
    ThreeLittlePigsNavigation(currentStep: $currentStep, isLeft:$isLeft)
}
