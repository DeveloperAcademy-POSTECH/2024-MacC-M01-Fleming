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
    
    // Popup과 연결되는 값들(Repeat 횟수)
    @State private var isPresented: Bool = true
    @State private var repeatNumber: Int = 1 // 반복횟수 저장
    // -> (추후)SwiftData와 결합 필요.
    
    var body: some View {
        ZStack {
            
            // 뷰 이동방법
            if currentStep == 0 {
                ThreeLittlePigs00(currentStep: $currentStep, isLeft: .constant(true))
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing), // 새 뷰는 오른쪽에서 등장
                        removal: .opacity))
                
                PopupView(isPresented: $isPresented, repeatNumber: $repeatNumber)
                    .onChange(of: isPresented){ currentStep = 1 }
//                    .onDisappear() { currentStep = 1 }
                
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
        case 1:
            ThreeLittlePigs01(currentStep: $currentStep, isLeft: $isLeft)
        case 2:
            ThreeLittlePigs02(currentStep: $currentStep, isLeft: $isLeft)
        case 3: // 카메라 앞 손움직이기 반복
            ThreeLittlePigs03_cam(currentStep: $currentStep, isLeft: $isLeft, repeatNumber: $repeatNumber)
        case 4:
            ThreeLittlePigs04(currentStep: $currentStep, isLeft: $isLeft)
        case 5:
            ThreeLittlePigs05(currentStep: $currentStep, isLeft: $isLeft)
        case 6: // 카메라 앞 손움직이기 반복
            ThreeLittlePigs06_cam(currentStep: $currentStep, isLeft: $isLeft, repeatNumber: $repeatNumber)
        case 7:
            ThreeLittlePigs07(currentStep: $currentStep, isLeft: $isLeft)
        case 8:
            ThreeLittlePigs08(currentStep: $currentStep, isLeft: $isLeft)
        case 9: // 카메라 앞 손움직이기 반복
            ThreeLittlePigs09_cam(currentStep: $currentStep, isLeft: $isLeft, repeatNumber: $repeatNumber)
        case 10:
            ThreeLittlePigs10(currentStep: $currentStep, isLeft: $isLeft)
        case 11:
            ThreeLittlePigs11(currentStep: $currentStep, isLeft: $isLeft)
        case 12:
            ThreeLittlePigs12(currentStep: $currentStep, isLeft: $isLeft)
        case 13:
            ThreeLittlePigs13_speech(currentStep: $currentStep, isLeft: $isLeft, repeatNumber: $repeatNumber)
        case 14:
            ThreeLittlePigs14(currentStep: $currentStep, isLeft: $isLeft)
        case 15:
            ThreeLittlePigs15_speech(currentStep: $currentStep, isLeft: $isLeft, repeatNumber: $repeatNumber)
        case 16:
            ThreeLittlePigs16(currentStep: $currentStep, isLeft: $isLeft)
        case 17:
            ThreeLittlePigs17_speech(currentStep: $currentStep, isLeft: $isLeft, repeatNumber: $repeatNumber)
        case 18:
            ThreeLittlePigs18(currentStep: $currentStep, isLeft: $isLeft)
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

// Repeat 기준
// 1. Cam: repeatNumber = 3 // -> 실제로 3번 object를 옮기게 한다.
// 2. Speech: repeatNumber = 3 // -> 4칸을 채우는 행위를 3번 하게 한다.
