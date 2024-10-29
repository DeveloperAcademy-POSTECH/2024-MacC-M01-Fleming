//
//  SplashView.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/9/24.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var currentStep = 1
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    
    var body: some View {
        ZStack {
            if isActive {
                BookarooView(currentStep: $currentStep, isLeft: .constant(true)) // Replace with the actual view you want to transition to
            } else {
        VStack(spacing: 20) {
            HStack(spacing: 0) {
                Text("Book")
                    .font(.system(size: 40, weight: .bold))
                Text("aroo")
                    .font(.system(size: 40))
            }
                .padding(.top, 20)
            Text("Rehabilitation")
                .font(.system(size: 50, weight: .bold))
            Text("for Kids")
                .font(.title3)
                .padding(.bottom, 20)
            Image("Bookarooy")
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth * 0.5, height: screenHeight * 0.4)
                .padding()
        }
        .frame(width: screenWidth, height: screenHeight)
        .background(Color.white) // 배경을 필요에 따라 조정하세요
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
