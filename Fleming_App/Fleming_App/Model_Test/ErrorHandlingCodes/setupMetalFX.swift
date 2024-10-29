//
//  setupMetalFX.swift
//  Fleming_App
//
//  Created by Leo Yoon on 10/29/24.
//

import Metal

func setupMetalFX() {
    #if !targetEnvironment(simulator)
    // MetalFX 관련 설정은 실제 기기에서만 실행
    if let device = MTLCreateSystemDefaultDevice(),
       device.supportsFamily(.apple8) { // 예시 조건
        // MetalFX 설정 코드
        print("MetalFX 설정 완료")
    }
    #else
    print("MetalFX는 시뮬레이터에서 지원되지 않습니다.")
    #endif
}
