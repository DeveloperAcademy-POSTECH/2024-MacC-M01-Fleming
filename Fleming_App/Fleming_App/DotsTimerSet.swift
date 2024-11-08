//
//  DotsTimerSet.swift
//  Fleming_App
//
//  Created by 임유리 on 11/7/24.
//
import SwiftUI

struct DotsTimerSet: View {
    @State private var isPresented: Bool = true
    @State private var repeatNumber: Int = 1 // 반복횟수 저장
    var body: some View{
        Image("DotsCirclesBackground")
            .resizable()
            .edgesIgnoringSafeArea(.all)
            .scaledToFill()
        //PopupView(isPresented: $isPresented, repeatNumber: $repeatNumber)
        
    }
}

#Preview {
    DotsTimerSet()
}
