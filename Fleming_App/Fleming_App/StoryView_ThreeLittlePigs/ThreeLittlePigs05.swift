//
//  ThreeLittlePigs05.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/10/24.
//

import SwiftUI

struct ThreeLittlePigs05: View {
    @Binding var currentStep: Int
    
    var body: some View {
        VStack {
            Text("ThreeLittlePigs05 View")
            Text("End of Navigation")
            
            Button(action: {
                // '완료' 버튼을 누르면 처음으로 돌아감
                currentStep = 1
            }) {
                Text("완료")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    ThreeLittlePigs05(currentStep: .constant(5))
}
