//
//  ARViewController.swift
//  CameraTest
//
//  Created by Leo Yoon on 10/28/24.
//
// SPDX-License-Identifier: MIT
// 원문출처: https://github.com/mdo91/HandPoseML


import SwiftUI
import Foundation
import ARKit // ARKit은 기본적으로 UIKit의 일종이라고 보면 되는듯...

// ARViewController를 사용할 수 있도록 연결해주는 뷰 컨테이너
struct ARViewContainer: UIViewControllerRepresentable {
    @Binding var labelText: String // String을 통해, SwiftUI와 UIKit사이에서 상태를 동기화함
    
    // 인스턴스 생성, labelText값을 전달.
    func makeUIViewController(context: Context) -> some UIViewController {
        let arViewController = ARViewController()
        arViewController.labelText = labelText
        return arViewController
    }
    
    // swiftUI 상태 변경시 호출 될 예정. labelText값을 ARViewController에 전달하여 UI 최신화 기능 유지
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        let viewController = uiViewController as? ARViewController
        viewController?.labelText = labelText
    }
}
