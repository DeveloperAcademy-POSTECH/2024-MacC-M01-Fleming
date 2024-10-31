//
//  CameraErrorFixing.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/31/24.
//
// 단독으로, 기기대응 연습을 위한 뷰
// 기기읽기 문제로, Preview 안 됨(할 필요도 없음).

import SwiftUI

struct CameraErrorFixing: View{
    var body: some View {
        
        Text("Hello, device!")
            .onAppear() {
                let deviceModel = UIDevice.current.model
                print("Device model: \(deviceModel)")
                print("Device model identifier: \(getModelType())")
            }
    }
}


// 기종이 LandScapeRight인지 확인하여, 기기대응하는 함수
func getModelType() -> String {
    // 모델 식별자를 가져오는 내부 함수
    func getModelIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let identifier = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in
                String(validatingUTF8: ptr)
            }
        }
        return identifier ?? "Unknown"
    }
    
    let modelIdentifier = getModelIdentifier()
    print(modelIdentifier)
    
    // Landscape Right 모델인지 여부를 점검(구버전)
//    let lrModels = ["iPad14,1", "iPad14,4", "iPad14,2", "iPad12,2", "iPad13,9", "iPad13,10","iPad13,1", "iPad13,2", "iPad13,3", "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7", "iPad13,8", "iPad13,9", "iPad13,10"]
    
    // Landscape Right 모델인지 여부를 점검(새버전-위키업뎃)
    let lrModels = ["iPad16,3", "iPad16,4", "iPad16,5", "iPad16,6", "iPad13,18", "iPad13,19","iPad14,5", "iPad14,6", "iPad14,8", "iPad14,9", "iPad14,10", "iPad14,11"]
    
    // 모델 식별자에 따른 출력
    return lrModels.contains(modelIdentifier) ? "LR" : "PT"
}
/// 부가설명: Landscape Right 모델은 아래와 같다.
/// (출처: https://en.wikipedia.org/wiki/List_of_iPad_models)
/// -> iPad Pro 11-inch (2024, M4): A2836, A2837, A3006 // iPad16,3 or iPad16,4*
/// -> iPad Pro 13-inch (2024, M4): A2925, A2926, A3007 // iPad16,5 or iPad 16,6*
/// -> iPad (2022, 10th generation): A2696, A2757, A2777 // iPad13,18 or iPad13,19 *
/// -> iPad Pro 12.9-inch (6th generation): A2436,A2437,A2764,A1766 // iPad14,5 or iPad14,6
///     => Apple 공홈에는 Landscape라고 되어있었음.
/// -> iPad Air 13-inch (2024, M2): A2898, A2899, A2900 // iPad14,8 or iPad14,9*
/// -> iPad Air 11-inch (2024, M2): A2902, A2903, A2904 // iPad14,10 or iPad14,11*
