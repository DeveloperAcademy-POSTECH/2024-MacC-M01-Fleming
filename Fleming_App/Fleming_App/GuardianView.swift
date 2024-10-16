import SwiftUI

struct GuardianView: View {
    @State private var toggleCategory1: Bool = true
    @State private var toggleCategory2: Bool = true
    @State private var toggleCategory3: Bool = true
    @State private var toggleCategory4: Bool = true
    @State private var toggleCategory5: Bool = true
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var body: some View { 
        NavigationView {
            VStack {
                HStack {
                    // 뒤로가기 버튼 추가
                    Button(action: {
                        // 뒤로가기 버튼의 동작 설정
                        // navigation stack에서 pop(이전 화면으로 돌아가기)
                    }) {
                        HStack {
                            Image(systemName: "arrow.left") // 뒤로가기 화살표 아이콘
                                .font(.title)
                        }
                        .foregroundColor(.black)
                    }
                    .padding(.leading, 20) // 왼쪽에 여백 추가
                    
                    Spacer() // 왼쪽 정렬 유지
                }
                .padding(.top, 10) // 상단에 약간의 여백 추가
                
                // 기존 GuardianView의 내용들
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
                HStack {
                    VStack(alignment: .leading) {
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
                
                HStack {
                    Toggle("Physic", isOn: $toggleCategory1)
                        .font(.system(size: 40))
                        .bold()
                        .foregroundStyle(AppColor.pigBrown)
                        .frame(width: screenWidth * 0.25)
                    
                    Toggle("Voice", isOn: $toggleCategory2)
                        .font(.system(size: 40))
                        .bold()
                        .foregroundStyle(AppColor.pigBrown)
                        .frame(width: screenWidth * 0.25)
                    
                    Toggle("Recognition", isOn: $toggleCategory3)
                        .font(.system(size: 40))
                        .bold()
                        .foregroundStyle(AppColor.pigBrown)
                        .frame(width: screenWidth * 0.25)
                }
                
                Spacer()
                
                HStack {
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
        .navigationViewStyle(StackNavigationViewStyle()) // iPad에서도 스택 네비게이션 강제
    }
}

#Preview {
    GuardianView()
}
