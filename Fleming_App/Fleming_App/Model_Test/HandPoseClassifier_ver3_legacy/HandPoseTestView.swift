////
////  HandPoseTestView.swift
////  Fleming_App
////
////  Created by Leo Yoon on 10/23/24.
////
//
//import SwiftUI
//
//struct HandPoseTestView: View {
//    @State private var rockProbability: Double = 0.0
//    @State private var paperProbability: Double = 0.0
//    @State private var scissorsProbability: Double = 0.0
//    
//    var body: some View {
//        VStack {
//            HandPoseView(rockProbability: $rockProbability, paperProbability: $paperProbability, scissorsProbability: $scissorsProbability)
//                .edgesIgnoringSafeArea(.all)
//            
//            VStack {
//                Text("Rock: \(rockProbability * 100, specifier: "%.2f")%")
//                Text("Paper: \(paperProbability * 100, specifier: "%.2f")%")
//                Text("Scissors: \(scissorsProbability * 100, specifier: "%.2f")%")
//            }
//            .font(.title)
//            .padding()
//            .background(Color.black.opacity(0.7))
//            .foregroundColor(.white)
//            .cornerRadius(10)
//            .padding(.top, 20)
//        }
//    }
//}
//
//struct HandPoseTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        HandPoseTestView()
//    }
//}
