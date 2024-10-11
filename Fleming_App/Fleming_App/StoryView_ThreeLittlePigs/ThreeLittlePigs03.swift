//
//  ThreeLittlePigs03.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/10/24.
//

import SwiftUI

struct ThreeLittlePigs03: View {
    @Binding var currentStep: Int
    
    var body: some View {
        VStack {
            Text("ThreeLittlePigs03 View")
            Button(action: {
                currentStep = 4 // 4단계로 이동
            }) {
                Text("Go to ThreeLittlePigs04")
            }
        }
    }
}

#Preview {
    ThreeLittlePigs03(currentStep: .constant(3))
}
