//
//  printCurrentTime.swift
//  Fleming_App
//
//  Created by Leo Yoon on 11/8/24.
//
// 에러를 뷰 업데이트와 비교하기 위해 만듦.

import Foundation

func printCurrentTime() {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let currentTime = formatter.string(from: Date())
    print("현재 시간: \(currentTime)")
}
