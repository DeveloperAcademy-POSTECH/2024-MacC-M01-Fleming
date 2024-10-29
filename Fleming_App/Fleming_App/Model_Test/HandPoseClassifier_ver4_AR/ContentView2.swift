//
//  ContentView2.swift
//  CameraTest
//
//  Created by Leo Yoon on 10/28/24.
//

import SwiftUI

struct ContentView2: View {
    
    @State private var labelText: String = ""
    var body: some View {
        
        ZStack {
            ARViewContainer(labelText: $labelText)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
            }
            .padding()
        }
        
    }
}

#Preview {
    ContentView2()
}
