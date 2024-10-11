//
//  Fleming_AppApp.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/7/24.
//

import SwiftUI

@main
struct Fleming_AppApp: App {
    var body: some Scene {
        WindowGroup {
//            ContentView()
//            MonitorSoundView() // Issue #1: 카메라 위에 애니메이션 & 음성넣기
//            FableView() // Issue #3: ui기본구성 연습, 카메라위에 png 올리기 및 애니메이션
            NavigationToggleView() // Issue #5: 동화넘기기 연습
        }
    }
}

#Preview {
 NavigationToggleView()
}
