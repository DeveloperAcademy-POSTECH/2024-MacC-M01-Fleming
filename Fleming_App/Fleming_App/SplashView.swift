//
//  SplashView.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/10/24.
//

import SwiftUI

struct SplashView: View{
    @Binding var currentStep: Int // 현재 뷰 상태 관리
    @Binding var isLeft : Bool // 동그라미가 왼쪽에 있는지 여부
    @State private var splashTab : Int = 0

    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationView{
            ZStack{
                
                Image("Background_splashView")
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
                            splashTab = 0
                            print("Bookaroo")
                        }, label:{
                            Text("Bookaroo")
                                .font(.title)
                                .foregroundStyle(.white)
                                .frame(width: 180, height: 50, alignment: .center)
                                .background(Color.brown)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                        })
                        
                        Text("")
                            .frame(width: 40)
                        
                        Button(action:{
                            splashTab = 1
                            print("Guardian")
                        }, label:{
                            Text("Guardian")
                                .font(.title)
                                .foregroundStyle(.white)
                                .frame(width: 180, height: 50, alignment: .center)
                                .background(Color.brown)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        })
                    }
                    .frame(height: screenHeight * 0.05)
                    
                    if splashTab == 0{
                        BookarooView(currentStep: $currentStep, isLeft: $isLeft)
                    } else if splashTab == 1 {
                        GuardianView()
                    }
                    
                }
                
            }
            .frame(width: screenWidth, height: screenHeight)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // iPad에서도 스택 네비게이션 강제
    }
        
}

#Preview {
    @Previewable @State var isLeft: Bool = false
    @Previewable @State var currentStep: Int = 1
    SplashView(currentStep: $currentStep, isLeft: $isLeft)
}
