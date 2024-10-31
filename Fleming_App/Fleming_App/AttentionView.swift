//
//  AttentionView.swift
//  Fleming_App
//
//  Created by 김도현 on 10/31/24.
//
import SwiftUI

struct AttentionView: View {
    @Binding var showPopup: Bool
    
    var body: some View {
        VStack {
            Text("Attention")
                .font(.system(size: UIScreen.main.bounds.width * 0.08, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.bottom,30)
            Spacer()
            Text("Please make sure there are no obstacles in the children's activities.")
                .font(.system(size: UIScreen.main.bounds.width * 0.03))
                .multilineTextAlignment(.center)
                .padding(.bottom,30)
                
            Button(action: {
                            showPopup = false
                        }) {
                            Text("Confirm")
                                .font(.system(size: UIScreen.main.bounds.width * 0.03,weight: .bold))
                                .padding()
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(100)
                        }
                        .padding(.top, 30)
            
        }
        .padding(30)
    }
}

struct AttentionView_Previews: PreviewProvider {
    static var previews: some View {
        AttentionView(showPopup: .constant(true))
    }
}

