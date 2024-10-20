//
//  RockPaperScissorsView.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/18/24.
//
// 영어식으로 하면, Rock Paper Scissors가 익숙하다고 합니다 ㅎㅎ

import SwiftUI

struct RockPaperScissorsView: View{
    @Binding var currentStep: Int
    @Binding var isNavigating3: Bool


    
    var body: some View {
        VStack{
            RockPaperScissors2()
        }
    }
}
