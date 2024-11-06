import SwiftUI

struct PopupView: View {
    @Binding var isPresented: Bool // 팝업이 나타나고 사라지는 상태를 제어하는 바인딩 변수
    @Binding var repeatNumber: Int // 선택된 숫자를 저장하는 상태 변수
    // -> 모든 스토리 뷰에서 (SwiftData로 읽어온 뒤) Binding으로 받아옴.
    
//    var onDismiss: () -> Void
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Repeat") // 팝업에 표시될 메인 텍스트
                .font(.system(size: CGFloat(80),weight: .semibold))
            //                .padding(.top,40)
            //                .padding(.bottom,10)
                .padding(.bottom, -20)
            Spacer()
            
            HStack (spacing: 80){ // 숫자 선택을 위한 HStack 추가
                Button(action: {
                    if repeatNumber > 1 {
                        repeatNumber -= 1
                    }
                }, label: {
                    //                    Text("-")
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 60))
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.gray)
                })
                
                Text("\(repeatNumber)")
                    .font(.system(size: 80))
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                
                Button(action: {
                    if repeatNumber < 5 {
                        repeatNumber += 1
                    }
                }) {
                    //                    Text("+")
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 60))
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.gray)
                }
            }
            //            .padding(.bottom,40)
            Spacer()
            
            // Start 버튼
            Button(action: {
                print("Selected Number: \(repeatNumber)")
                withAnimation {
                    isPresented = false
                }
            }, label: {
                Text("Start") // Start 버튼의 레이블
                    .font(.system(size: 60))
                    .fontWeight(.semibold)
                    .padding(.vertical, 5) // 상하 패딩을 유지
                    .padding(.horizontal, 100) // 좌우 패딩을 추가하여 길게 만듦 // 버튼의 전체 크기 키움
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(80)
            })
            Spacer()
        }
        .frame(width: screenWidth * 0.6, height: screenHeight * 0.6) // 팝업 뷰의 크기를 정의 (높이 조정)
        .background(Color.white.opacity(0.8)) // 팝업의 배경색을 정의
        .cornerRadius(50)
        .shadow(radius: 10) // 팝업의 그림자 효과
        .opacity(isPresented ? 1 : 0) // 팝업이 표시될 때의 불투명도 설정
        .animation(.easeInOut, value: isPresented) // 팝업이 나타나고 사라질 때의 애니메이션 설정
    }
}

#Preview {
    @Previewable @State var isPresented = true
    @Previewable @State var repeatNumber = 3

    PopupView(isPresented: $isPresented, repeatNumber: $repeatNumber)
}
