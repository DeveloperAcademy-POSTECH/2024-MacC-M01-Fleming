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
    @State private var currentStep: Int = 1 // 현재 뷰 상태 관리

    var body: some Scene {
        WindowGroup {
//            NavigationView{
//                SplashView()
//            }
//            .navigationViewStyle(StackNavigationViewStyle()) // iPad에서도 스택 네비게이션 강제

            //                SoundLevelView()
                SimpleTTSView()
        }
    }
}

#Preview {
    @Previewable @State var isLeft: Bool = false
    @Previewable @State var currentStep: Int = 1
    BookarooView(currentStep:$currentStep, isLeft:$isLeft)
}

//#Preview{
//        SoundLevelView()
//}
