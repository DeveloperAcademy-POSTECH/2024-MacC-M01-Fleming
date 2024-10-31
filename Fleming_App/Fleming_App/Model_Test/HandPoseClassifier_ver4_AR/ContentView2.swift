//
//  ContentView2.swift
//  CameraTest
//
//  Created by Leo Yoon on 10/28/24.
//

import SwiftUI

struct ContentView2: View {
    
    @State private var labelText: String = "손 모양을 인식 중..."
    @State private var secondLabelText: String = "손 모양 상태"
    @State private var confidenceValue: Int = 0
    
    var body: some View {
        
        ZStack {
            ARViewContainer(labelText: $labelText, secondLabelText: $secondLabelText, confidenceValue: $confidenceValue)
                .edgesIgnoringSafeArea(.all)
            
            // Text 잘 읽어지나 확인중
            VStack{
                Text("Label Text: \(labelText)")
                    .padding()
                    .background(Color.blue.opacity(0.6))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                
                Text("Second Label: \(secondLabelText)")
                    .padding()
                    .background(Color.green.opacity(0.6))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                
                Text("Third Label: \(confidenceValue)%의 확률")
                    .padding()
                    .background(Color.orange.opacity(0.6))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
        }
    }
}

#Preview {
    ContentView2()
}
