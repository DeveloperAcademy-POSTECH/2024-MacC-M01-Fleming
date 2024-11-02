import SwiftUI
import Vision
import AVFoundation

//struct checkDevice {
//    func getDeviceName() -> CameraDirection {
//        var systemInfo = utsname()
//        uname(&systemInfo)
//        
//        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
//            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in
//                String(validatingUTF8: ptr)
//            }
//        }
//        
//        guard let code = modelCode else { return .not }
//        
//        return mapToDevice(identifier: code)
//    }
//
//    func mapToDevice(identifier: String) -> CameraDirection {
//           switch identifier {
//               // Add all cases as in your original code
//           case "iPad13,18", "iPad13,19":
//               return .vertical
//               // more cases here...
//           case "x86_64", "arm64":
//               return .not
//           default:
//               return .not
//           }
//       }
//   }


enum CameraDirection_fordots {
    case vertical
    case horizontal
    case not

    func calculate(indexFingerTip: CGPoint, normalizedPoint: CGPoint) -> (CGPoint) {
        switch self {
        case .vertical:
            return CGPoint(x: indexFingerTip.x, y: 1 - indexFingerTip.y)

        case .horizontal: //변동해야함

            return CGPoint(x: 1 - indexFingerTip.x, y: indexFingerTip.y)

        case .not:
//                            break
            return normalizedPoint

        }
    }
}

//class checkDevice_fordots {
//    func getDeviceName() -> CameraDirection_fordots {
//        // Assuming this function returns the correct CameraDirection_fordots type
//        return .vertical // or any other direction
//    }
//}


// HandTrackingGameView는 UIViewControllerRepresentable을 구현하여 SwiftUI에서 사용할 수 있는 뷰를 제공합니다.
struct HandTrackingGameView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return HandTrackingGameViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}



// HandTrackingGameViewController는 손 추적 및 게임 로직을 구현하는 UIViewController입니다.
class HandTrackingGameViewController: UIViewController {
    private var captureSession: AVCaptureSession! // 카메라 캡처 세션
    private var videoOutput: AVCaptureVideoDataOutput! // 비디오 출력
    private var previewLayer: AVCaptureVideoPreviewLayer! // 카메라 미리보기 레이어
    private var fingerTipView: UIView! // 손가락 끝을 표시하는 뷰
    private var drawnPath = UIBezierPath() // 손가락 이동 경로를 저장하는 베지어 경로
    private var pathLayer: CAShapeLayer! // 손가락 경로를 그릴 레이어
    private var startTouched = false // 파란색 원에 닿았는지 여부를 나타내는 플래그
    private var blueCircleFrame: CGRect! // 파란색 원의 프레임
    private var greenCircleFrame: CGRect! // 초록색 원의 프레임
    
//    //by hera
    var CameraDirection_fordots: CameraDirection_fordots = .vertical //멤버변수 vertical을 초기값으로 설정
    private let deviceChecker = checkDevice_fordots() //여기서
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CameraDirection_fordots = deviceChecker.getDeviceName() //여기에서 방향 판단하기 by hera

        Text("!!!!!")
        
        setupCaptureSession() // 카메라 캡처 세션 설정
        setupFingerTipView() // 손가락 끝을 나타낼 뷰 설정
        setupPathLayer() // 경로를 그릴 레이어 설정
        setupGameCircles() // 게임에 사용될 원들 설정
    }
    
    // 카메라 캡처 세션을 설정하는 함수
    private func setupCaptureSession() {
        captureSession = AVCaptureSession()
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // 카메라 권한이 승인된 경우 세션 설정 후 시작
            configureCaptureSession()
            captureSession.startRunning()
        case .notDetermined:
            // 카메라 권한이 요청되지 않은 경우 요청
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.configureCaptureSession()
                        self.captureSession.startRunning()
                    }
                }
            }
        case .denied, .restricted:
            // 카메라 접근이 거부되었거나 제한된 경우
            print("Camera access denied or restricted.")
        default:
            break
        }
    }
    
    // 카메라 캡처 세션을 구성하는 함수
    private func configureCaptureSession() {
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        
        videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill

        if let connection = previewLayer.connection, connection.isVideoOrientationSupported {
            connection.videoOrientation = .landscapeRight
        } else if let connection = videoOutput.connection(with: .video) {
            connection.videoOrientation = .landscapeRight
        }
        previewLayer.frame = view.bounds
        
        view.layer.addSublayer(previewLayer) // 미리보기 레이어를 뷰에 추가
    }
    
    // 손가락 끝을 표시하는 뷰 설정 함수
    private func setupFingerTipView() {
        fingerTipView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        fingerTipView.backgroundColor = .red
        fingerTipView.layer.cornerRadius = 10
        fingerTipView.isHidden = false
        view.addSubview(fingerTipView)
    }
    
    // 손가락 경로를 그릴 레이어 설정 함수
    private func setupPathLayer() {
        pathLayer = CAShapeLayer()
        pathLayer.strokeColor = UIColor.blue.cgColor
        pathLayer.fillColor = UIColor.clear.cgColor
        pathLayer.lineWidth = 5
        view.layer.addSublayer(pathLayer)
    }
    
    // 게임에서 사용할 파란색과 초록색 원 설정 함수
    private func setupGameCircles() {
        let blueCircle = UIView(frame: CGRect(x: 50, y: view.bounds.midY - 25, width: 50, height: 50))
        blueCircle.backgroundColor = .blue
        blueCircle.layer.cornerRadius = 25
        view.addSubview(blueCircle)
        blueCircleFrame = blueCircle.frame
        
        let greenCircle = UIView(frame: CGRect(x: view.bounds.width - 100, y: view.bounds.midY - 25, width: 50, height: 50))
        greenCircle.backgroundColor = .green
        greenCircle.layer.cornerRadius = 25
        view.addSubview(greenCircle)
        greenCircleFrame = greenCircle.frame
    }
}

// AVCaptureVideoDataOutputSampleBufferDelegate를 구현하여 프레임 처리 및 손 추적을 수행합니다.
extension HandTrackingGameViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .upMirrored, options: [:])
        let handPoseRequest = VNDetectHumanHandPoseRequest()
        
        do {
            try requestHandler.perform([handPoseRequest])
            if let results = handPoseRequest.results {
                for observation in results {
                    if let indexFingerTip = try? observation.recognizedPoint(.indexTip),
                       indexFingerTip.confidence > 0.5 {
                        //여기 부분
//                        let normalizedPoint = CGPoint(x: 1 - indexFingerTip.location.x, y: 1 - indexFingerTip.location.y)
//                        //여기 부분
//                        let normalizedPoint = self.CameraDirection_fordots.calculate(indexFingerTip: indexFingerTip.location)
                        
                        
                        DispatchQueue.main.async {
                            let nomalizedPoint = indexFingerTip.location
                            let convertedPoint = self.previewLayer.layerPointConverted(fromCaptureDevicePoint: self.CameraDirection_fordots.calculate(indexFingerTip: nomalizedPoint, normalizedPoint: nomalizedPoint))
                            
                            self.fingerTipView.center = convertedPoint
                            self.fingerTipView.isHidden = false
                            
                            // 파란색 원에 손가락이 닿았는지 확인하여 경로 그리기 시작
                            if self.blueCircleFrame.contains(convertedPoint), !self.startTouched {
                                self.startTouched = true
                                self.drawnPath.move(to: convertedPoint)
                            }
                            
                            // 경로 그리기 시작된 경우 계속해서 선을 그림
                            if self.startTouched {
                                self.drawnPath.addLine(to: convertedPoint)
                                self.pathLayer.path = self.drawnPath.cgPath
                            }
                            
                            // 초록색 원에 손가락이 닿았는지 확인하여 게임 종료 처리
                            if self.greenCircleFrame.contains(convertedPoint), self.startTouched {
                                self.displaySuccessMessage()
                                self.startTouched = false
                                self.drawnPath.removeAllPoints()
                            }
                        }
                    }
                }
            }
        } catch {
            print("Error performing hand pose request: \(error)")
        }
    }
    
    // 성공 메시지를 화면에 표시하는 함수
    private func displaySuccessMessage() {
        let successLabel = UILabel(frame: CGRect(x: view.bounds.midX - 50, y: view.bounds.midY - 150, width: 100, height: 50))
        successLabel.text = "Success"
        successLabel.textColor = .green
        successLabel.textAlignment = .center
        successLabel.font = UIFont.boldSystemFont(ofSize: 24)
        view.addSubview(successLabel)
        
        // 2초 후 성공 메시지 제거
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            successLabel.removeFromSuperview()
        }
    }
}

// SwiftUI StoryView_Dots 구조체
struct StoryView_Dots: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        ZStack {
            HandTrackingGameView()
                .edgesIgnoringSafeArea(.all)
                //
        }
    }
}

#Preview {
    StoryView_Dots()
}
