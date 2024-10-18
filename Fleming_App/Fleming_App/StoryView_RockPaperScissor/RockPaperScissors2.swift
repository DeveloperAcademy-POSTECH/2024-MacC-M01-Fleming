//
//  RockPapeerScissors2.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/18/24.
//

import SwiftUI

struct RockPaperScissors2: View{
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var body: some View{
        ZStack{
            Image("Background_RPSView")
                .resizable()
                .scaledToFill()
                .frame(width: screenWidth, height: screenHeight, alignment: .center)
                .offset(x:0, y:0)
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                
                Text("Rock Paper Scissors !")
                    .font(.system(size: 80, weight: .bold))
                    .foregroundStyle(.blue)
                    .padding(.bottom, screenHeight * 0.05)
             
                HStack(spacing: screenWidth * 0.1){
                    // 상대방 미리낼 것
                    VStack{
                        Text("Friend")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundStyle(.blue)
                        
                        ZStack{
                            Rectangle()
                                .foregroundStyle(Color(AppColor.handBackgroundColor))
                                .frame(width:screenHeight * 0.5, height: screenHeight * 0.5)
                                .clipShape(ButtonBorderShape.roundedRectangle(radius: 50))
                            
                            Image("object_RockPaperScissors_Rock")
                                .frame(width: screenHeight * 0.3)
                            
                        }
                    }
                    
                    // 내가 낼 것
                    VStack{
                        Text("Me")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundStyle(.blue)
                        
                        ZStack{
                            Rectangle()
                                .foregroundStyle(Color(AppColor.handBackgroundColor))
                                .frame(width:screenHeight * 0.5, height: screenHeight * 0.5)
                                .clipShape(ButtonBorderShape.roundedRectangle(radius: 50))
                            
                            Text("Camera")
                        }
                    }
                }
                
            }
        }
    }
}

#Preview{
    RockPaperScissors2()
}
