//
//  RockPaperScissors3.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/18/24.
//

import SwiftUI

struct RockPaperScissors3 : View {
    @Environment(\.dismiss) var dismiss
//    @Binding var currentStep: Int

    var body : some View {
        Text("You win the Game!")
            .font(.system(size: 64))
            .bold()
            .foregroundStyle(.blue)
            .background(Color.white)
            .frame(alignment:.center)
        Text("   Horray!")
            .font(.system(size: 64))
            .bold()
            .foregroundStyle(.blue)
            .background(Color.white)
            .frame(alignment:.center)
        
    }
}
