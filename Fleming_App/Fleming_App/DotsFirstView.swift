//
//  DotsFirstView.swift
//  Fleming_App
//
//  Created by 임유리 on 11/7/24.
//

import SwiftUI

extension Color {
    static let customYellow = Color(hex:"F4DB06")
}

var screenWidth = UIScreen.main.bounds.width
var screenHeight = UIScreen.main.bounds.height

struct DotsFirstView : View {
    var body: some View {
        ZStack{
            Color.customYellow.edgesIgnoringSafeArea(.all)
            HStack(spacing: 10){
                VStack(alignment: .leading ,spacing: 15){
                    Text("Dots")
                        .foregroundColor(Color.customBrown)
                        .bold()
                        .font(.system(size: 128))
                    
                    Text("Connect me into the World")
                        .foregroundColor(Color.customBrown)
                        .bold()
                        .font(.system(size: 36))
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 50)
                
                VStack{
                    Image("DotsRight")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.5)
                }
                .padding(.trailing, 50)
            }
            
        }
    }
}


#Preview {
    DotsFirstView()
}
