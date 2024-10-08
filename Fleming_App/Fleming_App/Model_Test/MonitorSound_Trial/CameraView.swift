//
//  CameraView.swift
//  BoBuSang_Trial
//
//  Created by Leo Yoon on 10/7/24.
//

import SwiftUI
import AVFoundation
import UIKit

struct CameraView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: CameraViewModel
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = CameraViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // 필요시 업데이트
    }
}

class CameraViewController: UIViewController {
    var viewModel: CameraViewModel?
    var previewLayer: AVCaptureVideoPreviewLayer? // 뷰 레이아웃 변경용
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.setupCamera()
        setupPreviewLayer()
    }
    
    func setupPreviewLayer() {
        guard let captureSession = viewModel?.captureSession else { return }
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspect // 화면에 맞추되 비율 유지하며 여백 추가
        view.layer.addSublayer(previewLayer)
        self.previewLayer = previewLayer
    }
    
    // 뷰의 레이아웃이 변경될 때마다 호출되어 레이어 크기를 조정
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            previewLayer?.frame = view.bounds // 화면의 전체 좌우폭에 맞게 크기 설정
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.stopSession()
    }
}
