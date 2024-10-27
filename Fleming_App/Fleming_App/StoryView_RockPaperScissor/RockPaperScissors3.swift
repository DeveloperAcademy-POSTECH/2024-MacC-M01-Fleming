//
//  RockPaperScissors3.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/18/24.
//

import SwiftUI

struct RockPaperScissors3 : View{
    @Environment(\.dismiss) var dismiss
    @Binding var currentStep: Int

    var body : some View {
        Text("You Win 3 Times!\nHorray!")
            .font(.system(size: 64))
            .foregroundStyle(.red)
            .background(Color.white)
            .frame(alignment:.center)
        
//        NavigationLink("A 창으로 바로 이동", destination: BookarooView(currentStep: .constant(1), isLeft: .constant(false)))
//                        .padding()
//                        .background(Color.red)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
        
//        // 강제로 돌아가기(UIKit으로 꺼버리기)
//        Button("A 창으로 바로 돌아가기") {
//                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//                            windowScene.windows.first?.rootViewController?.dismiss(animated: true)
//                        }
//                    }
//                    .padding()
//                    .background(Color.red)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//        
//        // 창을 초기화하고 BookarooView로 돌아가기
//        Button("모든 창 닫고 처음으로 돌아가기") {
//                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                           let rootViewController = windowScene.windows.first?.rootViewController {
//                            rootViewController.dismiss(animated: true) {
//                                // 네비게이션 스택을 AView로 초기화하여 루트로 이동
//                                if let navigationController = rootViewController as? UINavigationController {
//                                    navigationController.popToRootViewController(animated: true)
//                                }
//                            }
//                        }
//                    }
//                    .padding()
//                    .background(Color.red)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
        
    }
}
