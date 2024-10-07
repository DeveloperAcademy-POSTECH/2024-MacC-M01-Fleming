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
            MonitorSoundView() // Issue #1: 카메라 위에 애니메이션 & 음성넣기
        }
    }
}

#Preview {
 MonitorSoundView()
}
