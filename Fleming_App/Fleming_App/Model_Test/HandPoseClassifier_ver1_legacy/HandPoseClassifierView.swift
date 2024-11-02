////
////  HandPoseClassifierView.swift
////  Fleming_App
////
////  Created by Leo Yoon on 10/23/24.
////
//
//import SwiftUI
//import AVFoundation
//import Vision
//import CoreML
//
//struct HandPoseClassifierView: View {
//    @State private var classificationLabel: String = "Analyzing..."
//    
//    var body: some View {
//        VStack {
//            
//            CameraView(classificationLabel: $classificationLabel)
//                            .edgesIgnoringSafeArea(.all)
//                        
//                        Text("Hand Gesture: \(classificationLabel)")
//                            .font(.largeTitle)
//                            .padding()
//            
//        }
//    }
//}
//
//struct HandPoseClassifierView_Previews: PreviewProvider {
//    static var previews: some View {
//        HandPoseClassifierView()
//    }
//}
