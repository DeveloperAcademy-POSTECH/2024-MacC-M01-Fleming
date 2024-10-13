//
//  ThreeLittlePigs04.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/10/24.
//

import SwiftUI

struct ThreeLittlePigs04: View {
    @Binding var currentStep: Int
    
    var body: some View {
        VStack {
            Text("ThreeLittlePigs04 View")
            Button(action: {
                currentStep = 5 // 5단계로 이동
            }) {
                Text("Go to ThreeLittlePigs05")
            }
        }
    }
}

#Preview {
    ThreeLittlePigs04(currentStep: .constant(4))
}
