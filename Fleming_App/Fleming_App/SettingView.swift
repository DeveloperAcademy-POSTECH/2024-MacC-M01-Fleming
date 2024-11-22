//
//  SettingView.swift
//  Fleming_App
//
//  Created by Leo Yoon on 11/21/24.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var settingVariables: SettingVariables
    
    var body: some View{

            // 스크롤뷰(설정칸 - 스크롤 안되게 해둠)
            VStack{
                // (임시표시) Sound
                HStack{
                    Spacer().frame(width: screenWidth * 0.025)
                    Text("SOUND")
                        .font(.system(size:48, weight:.bold))
                        .foregroundStyle(.white)
                        .frame(width: 300, alignment: .leading)
                    Spacer()
                }
                
                // (임시표시) Sound-detail
                VStack(){
                    HStack(spacing: 40){
                        Text("Background")
                            .font(.system(size:40, weight:.bold))
                            .foregroundStyle(.white)
                            .frame(width:320, alignment:.leading)
                        
                        Image("Button_PlaySound2")
                            .resizable()
                            .scaledToFit()
                            .frame(width:48)
                        
                        Slider(
                            value: Binding(
                                get: { settingVariables.volumeBackground },
                                set: { newValue in
                                    settingVariables.volumeBackground = Float(newValue)
                                }
                            ),
                            in: 0...1,
                            step: 0.25
                        )
                        .accentColor(.white)
                        .frame(width: screenWidth * 0.3)
                    }
                    
                    HStack(spacing:40){
                        Text("Text Sound")
                            .font(.system(size:40, weight:.bold))
                            .foregroundStyle(.white)
                            .frame(width:320, alignment: .leading)
                        
                        Image("Button_PlaySound2")
                            .resizable()
                            .scaledToFit()
                            .frame(width:48)
                        
                        Slider(
                            value: Binding(
                                get: { settingVariables.volumeTTS },
                                set: { newValue in
                                    settingVariables.volumeTTS = Float(newValue)
                                }
                            ),
                            in: 0...1,
                            step: 0.25
                        )
                        .accentColor(.white)
                        .frame(width: screenWidth * 0.3)
                    }
                }
                
                // (임시표시)Language
                HStack{
                    Spacer().frame(width: screenWidth * 0.025)
                    
                    Text("Language")
                        .font(.system(size:48, weight:.bold))
                        .foregroundStyle(.white)
                        .frame(width: 300, alignment: .leading)
                    
                    Spacer()
                    
                    Button(action:{
                        settingVariables.selectedLanguage = "ko"
                        print(settingVariables.selectedLanguage)
                    }, label:{
                        
                        if settingVariables.selectedLanguage == "ko" {
                            Text("Korean")
                                .font(.system(size:48, weight:.bold))
                                .foregroundStyle(.white)
                                .padding(10)
                        } else {
                            Text("Korean")
                                .font(.system(size:48, weight:.bold))
                                .foregroundStyle(.white)
                                .padding(10)
                                .opacity(0.4)
                        }
                    })
                    
                    Spacer().frame(width: screenWidth * 0.05)
                    
                    Button(action:{
                        settingVariables.selectedLanguage = "en"
                        print(settingVariables.selectedLanguage)
                    }, label:{
                        if settingVariables.selectedLanguage == "en" {
                            Text("English")
                                .font(.system(size:48, weight:.bold))
                                .foregroundStyle(.white)
                                .padding(10)
                        } else {
                            Text("English")
                                .font(.system(size:48, weight:.bold))
                                .foregroundStyle(.white)
                                .padding(10)
                                .opacity(0.4)
                        }
                    })
                    Spacer()
                }
                
                // (임시표시) 언어설정 알림
                HStack{
                    Spacer()
                    Text("* Language setting is adpted after restarting the app.")
                        .font(.system(size:24, weight:.bold))
                        .foregroundStyle(.white)
                        .padding(10)
                        .opacity(0.4)
                        .frame(width: 700)
                    Spacer().frame(width: screenWidth * 0.02)
                }
                .offset(y: -screenHeight * 0.05)
                
                Spacer()
            }
            .frame(width:screenWidth, height: screenHeight * 0.55)
            .id(settingVariables.selectedLanguage)
        // 언어변경시 새로고침
//            .onChange(of: settingVariables.selectedLanguage) { newLanguage in
//                            settingVariables.reloadAppBundle()
//                        }
    }
}

