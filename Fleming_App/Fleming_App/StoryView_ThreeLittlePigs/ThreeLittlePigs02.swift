//
//  ThreeLittlePigs02.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/10/24.
//

import SwiftUI

struct ThreeLittlePigs02: View {
    @Binding var currentStep: Int
    
    var body: some View {
        
        VStack {
            Text("ThreeLittlePigs02 View")
            Button(action: {
                currentStep = 3 // 3단계로 이동
            }) {
                Text("Go to ThreeLittlePigs03")
            }
        }
    }
}

#Preview {
    ThreeLittlePigs02(currentStep: .constant(2))
}
