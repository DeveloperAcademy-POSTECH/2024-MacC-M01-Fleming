import SwiftUI

struct PopupView: View {
    @Binding var isPresented: Bool // 팝업이 나타나고 사라지는 상태를 제어하는 바인딩 변수
    @State private var selectedNumber: Int = 1 // 선택된 숫자를 저장하는 상태 변수
    
    var body: some View {
        VStack {
            Text("Repeat") // 팝업에 표시될 메인 텍스트
                .font(.system(size: CGFloat(selectedNumber * 60),weight: .bold))
                
                .padding(.top,50)
                .padding(.bottom,10)

            
            HStack (spacing: 80){ // 숫자 선택을 위한 HStack 추가
                Button(action: {
                    if selectedNumber > 1 {
                        selectedNumber -= 1
                    }
                }) {
                    Text("-")
                        .font(.system(size: CGFloat(selectedNumber * 100)))
//                        .frame(width: 44, height: 44)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.black)

                }
                
                Text("\(selectedNumber)")
                    .font(.system(size: CGFloat(selectedNumber * 100)))
                    .padding(.horizontal)
                
                Button(action: {
                    if selectedNumber < 5 {
                        selectedNumber += 1
                    }
                }) {
                    Text("+")
                        .font(.system(size: CGFloat(selectedNumber * 100)))
//                        .frame(width: 44, height: 44)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.black)

                }
            }
            .padding(.bottom,40)
            
            Button(action: { // Start 버튼의 액션 정의
                print("Selected Number: \(selectedNumber)")
                withAnimation {
                    isPresented = false
                }
            })
            {
                Text("Start") // Start 버튼의 레이블
                    .font(.system(size: CGFloat(selectedNumber * 60)))
                                    .padding(.vertical, 5) // 상하 패딩을 유지
                                    .padding(.horizontal, 90) // 좌우 패딩을 추가하여 길게 만듦 // 버튼의 전체 크기 키움
                                    .background(Color.black)
                                    .foregroundColor(.white)
                                    .cornerRadius(80)
                
            }

            
        }
        .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.6) // 팝업 뷰의 크기를 정의 (높이 조정)
        .background(Color.white.opacity(0.8)) // 팝업의 배경색을 정의
        .cornerRadius(50)
        .shadow(radius: 10) // 팝업의 그림자 효과
        .opacity(isPresented ? 1 : 0) // 팝업이 표시될 때의 불투명도 설정
        .animation(.easeInOut, value: isPresented) // 팝업이 나타나고 사라질 때의 애니메이션 설정
    }
}

struct PopupView_Previews: PreviewProvider {
    static var previews: some View {
        PopupView(isPresented: .constant(true))
    }
}

