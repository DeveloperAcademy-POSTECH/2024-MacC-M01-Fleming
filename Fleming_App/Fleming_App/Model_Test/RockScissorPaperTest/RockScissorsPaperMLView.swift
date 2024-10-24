//
//  RockScissorsPaperMLView.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/18/24.
//

import SwiftUI

struct RockScissorsPaperMLView: View {
    @ObservedObject var model = RockScissorsPaperMLModel()
    
    var body: some View {
        VStack {
            Text("카메라에 비친 손을 보고 가위/바위/보 인식")
                .font(.title)
                .padding()
            
            RSP_CameraView(model: model)
                .frame(width: 500, height: 500) // 카메라 뷰 크기를 500x500으로 설정
                .scaledToFit()
                .clipped() // 부모 뷰 바깥의 콘텐츠를 자르기
            
            Text("예측 결과: \(model.predictionLabel)")
                .font(.title2)
                .padding()
            
            Spacer()
        }
    }
}

struct RSP_CameraView: UIViewControllerRepresentable {
    var model: RockScissorsPaperMLModel
    
    func makeUIViewController(context: Context) -> RSP_CameraViewController {
        let controller = RSP_CameraViewController()
        controller.model = model
        return controller
    }
    
    func updateUIViewController(_ uiViewController: RSP_CameraViewController, context: Context) {}
}

class RSP_CameraViewController: UIViewController {
    var model: RockScissorsPaperMLModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let model = model else { return }
        model.setupCamera(for: self.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        model?.stopCamera()
    }
}

#Preview {
    RockScissorsPaperMLView()
}
