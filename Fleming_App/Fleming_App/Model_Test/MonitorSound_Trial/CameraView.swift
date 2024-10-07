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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.setupCamera()
        setupPreviewLayer()
    }
    
    func setupPreviewLayer() {
        guard let captureSession = viewModel?.captureSession else { return }
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill // 정확한 타입 지정
        view.layer.addSublayer(previewLayer)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.stopSession()
    }
}
