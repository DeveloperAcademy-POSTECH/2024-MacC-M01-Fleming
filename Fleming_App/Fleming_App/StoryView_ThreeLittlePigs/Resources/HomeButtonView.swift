//
//  HomeButtonView.swift
//  Fleming_App
//
//  Created by Leo Yoon on 11/6/24.
//
import SwiftUI

struct HomeButtonView : View {
    @Environment(\.dismiss) private var dismiss
    var screenWidth = UIScreen.main.bounds.width

    var body: some View {
        Button(action:{
            dismiss()
        }, label: {
            Image("Button_home")
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth * 0.03)
        })
    }
}
