//
//  SplashView.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/10/24.
//

import SwiftUI

struct SplashView: View{
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        
        ZStack{
            
            Image("iPad mini 8.3 - _pig_background")
                .resizable()
                .scaledToFill()
                .frame(width: screenWidth, alignment: .center)
                .offset(x:0, y:0)
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                
                Spacer(minLength: 40)
                //탭버튼
                HStack{
                    Button(action:{
                        print("버튼클릭 1")
                    }, label:{
                        Text("Training")
                            .font(.title)
                            .foregroundStyle(.white)
                            .frame(width: 180, height: 50, alignment: .center)
                            .background(Color.brown)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                    })
                    
                    Text("")
                        .frame(width: 40)
                    
                    Button(action:{
                        print("버튼클릭 2")
                    }, label:{
                        Text("Report")
                            .font(.title)
                            .foregroundStyle(.white)
                            .frame(width: 180, height: 50, alignment: .center)
                            .background(Color.brown)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    })
                }
                
                
                Text("Hi Leo")
                    .font(.system(size: 128))
                    .bold()
                    .frame(width: screenWidth-80, alignment: .leading)
                
                Text("Today's Training")
                    .font(.system(size:48))
                    .frame(width: screenWidth-80, alignment: .leading)
                
                ScrollView(.horizontal){
                    LazyHStack(spacing: 40) {
                        ForEach(0..<10) { index in
                            VStack(alignment:.leading) {
                                Button(action: {
                                    print("\(index+1)번 동화 클릭")
                                },label:{Rectangle()
                                        .fill(Color.gray)
                                        .frame(width: 0.20 * screenWidth, height: 0.40 * screenHeight)
                                        .overlay(
                                            Text("\(index+1)번 동화")
                                                .font(.title)
                                                .foregroundStyle(.white)
                                        )
                                })
                                
                                HStack{
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width:60)
                                        .padding(.horizontal, 10)
                                    
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width:60)
                                        .padding(.horizontal, 10)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                            }
                        }
                    }
                }
                .padding(.horizontal, 40)
                
            }
            
        }
        .frame(width: screenWidth, height: screenHeight)
        
    }
        
}

#Preview {
    SplashView()
}
