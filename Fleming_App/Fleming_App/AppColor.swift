//
//  AppColor.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/11/24.
//

import SwiftUI

class AppColor {
    // Three Little Pigs
    static let pigBrown = Color(hex: "#996736")
    
    // RockPaperScissors
    static let handColor = Color(hex: "#63C1FE")
    static let handColor2 = Color(hex: "#FFCE1F")
    static let handBackgroundColor = Color(hex: "#D9D9D9")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 1)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}
