//
//  GuardianView.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/15/24.
//

import SwiftUI

struct GuardianView: View{
    @State private var toggleCategory1: Bool = true
    @State private var toggleCategory2: Bool = true
    @State private var toggleCategory3: Bool = true
    @State private var toggleCategory4: Bool = true
    @State private var toggleCategory5: Bool = true
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var body: some View{
        VStack{
            HStack(alignment: .bottom, spacing: 40){
                Text("Hi Leo")
                    .font(.system(size: 128))
                    .bold()
                    .foregroundStyle(AppColor.pigBrown)
                
                Text("8, Boy")
                    .font(.system(size: 40))
                    .bold()
                    .foregroundStyle(AppColor.pigBrown)
            }
            .frame(width: screenWidth-80, alignment: .leading)
            
            Spacer()
            HStack{
                VStack(alignment: .leading){
                    Text("Attending physician :")
                        .font(.system(size: 40))
                        .bold()
                        .foregroundStyle(AppColor.pigBrown)
                    Text("Note :")
                        .font(.system(size: 40))
                        .bold()
                        .foregroundStyle(AppColor.pigBrown)
                    Text("Mode :")
                        .font(.system(size: 40))
                        .bold()
                        .foregroundStyle(AppColor.pigBrown)
                }
                Spacer()
            }
            
            Spacer()
            
            HStack(){
                
                Toggle("Physic", isOn: $toggleCategory1)
                    .font(.system(size: 40))
                    .bold()
                    .foregroundStyle(AppColor.pigBrown)
                    .frame(width:screenWidth * 0.25)
                
                Toggle("Voice", isOn: $toggleCategory2)
                    .font(.system(size: 40))
                    .bold()
                    .foregroundStyle(AppColor.pigBrown)
                    .frame(width:screenWidth * 0.25)
                
                Toggle("Recognition", isOn: $toggleCategory3)
                    .font(.system(size: 40))
                    .bold()
                    .foregroundStyle(AppColor.pigBrown)
                    .frame(width:screenWidth * 0.25)
            }
            
            Spacer()
            
            HStack{
                
                Toggle("Concentrate", isOn: $toggleCategory4)
                    .font(.system(size: 40))
                    .bold()
                    .foregroundStyle(AppColor.pigBrown)
                    .frame(width: screenWidth * 0.25)
                
                Toggle("Voice", isOn: $toggleCategory5)
                    .font(.system(size: 40))
                    .bold()
                    .foregroundStyle(AppColor.pigBrown)
                    .frame(width: screenWidth * 0.25)
                
                Text(" ")
                    .frame(width: screenWidth * 0.25)
            }
            Spacer()
        }
        .frame(height: screenHeight * 0.85)
    }
}

#Preview{
    GuardianView()
}
