//
//  checkDevice.swift
//  Fleming_App
//
//  Created by 임유리 on 10/24/24.
//
//
import SwiftUI

enum CameraDirection {
    case horizontal
    case vertical
    case not
}

struct checkDevice {
    @State private var deviceName: String = ""

    func getDeviceName() -> CameraDirection {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        
        guard let code = modelCode else { return CameraDirection.not }
        
        return mapToDevice(identifier: code)
    }
    
    func mapToDevice(identifier: String) -> CameraDirection {
        switch identifier {
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
            return CameraDirection.horizontal
        case "iPad3,1", "iPad3,2", "iPad3,3":
            return CameraDirection.horizontal
        case "iPad3,4", "iPad3,5", "iPad3,6":
            return CameraDirection.horizontal
        case "iPad4,1", "iPad4,2", "iPad4,3":
            return CameraDirection.horizontal
        case "iPad5,3", "iPad5,4":
            return CameraDirection.horizontal
        case "iPad6,11", "iPad6,12":
            return CameraDirection.horizontal
        case "iPad7,5", "iPad7,6":
            return CameraDirection.horizontal
        case "iPad11,3", "iPad11,4":
            return CameraDirection.horizontal
        case "iPad7,11", "iPad7,12":
            return CameraDirection.horizontal
        case "iPad11,6", "iPad11,7":
            return CameraDirection.horizontal
        case "iPad12,1", "iPad12,2":
            return CameraDirection.horizontal
        case "iPad13,18", "iPad13,19":
            return CameraDirection.vertical
            //"iPad 10"
        case "iPad13,1", "iPad13,2":
            return CameraDirection.horizontal
        case "iPad13,16", "iPad13,17":
            return CameraDirection.horizontal
        case "iPad2,5", "iPad2,6", "iPad2,7":
            return CameraDirection.horizontal
        case "iPad4,4", "iPad4,5", "iPad4,6":
            return CameraDirection.horizontal
        case "iPad4,7", "iPad4,8", "iPad4,9":
            return CameraDirection.horizontal
        case "iPad5,1", "iPad5,2":
            return CameraDirection.horizontal
        case "iPad11,1", "iPad11,2":
            return CameraDirection.horizontal
        case "iPad14,1", "iPad14,2":
            return CameraDirection.horizontal
        case "iPad6,3", "iPad6,4":
            return CameraDirection.horizontal
        case "iPad6,7", "iPad6,8":
            return CameraDirection.horizontal
        case "iPad7,1", "iPad7,2":
            return CameraDirection.horizontal
        case "iPad7,3", "iPad7,4":
            return CameraDirection.horizontal
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":
            return CameraDirection.horizontal
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":
            return CameraDirection.horizontal
        case "iPad8,9", "iPad8,10":
            return CameraDirection.horizontal
        case "iPad8,11", "iPad8,12":
            return CameraDirection.horizontal
        case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7":
            return CameraDirection.horizontal
        case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11":
            return CameraDirection.horizontal
        case "iPad14,3", "iPad14,4":
            return CameraDirection.vertical
            //"iPad Pro 11-inch (6th generation)"
        case "iPad14,5", "iPad14,6":
            return CameraDirection.vertical
            //"iPad Pro 12.9-inch (6th generation)"
        case "iPad14,10", "iPad14,11":
            return CameraDirection.vertical
        case "iPad14,8", "iPad14,9":
            return CameraDirection.horizontal
        case "iPad16,5":
            return CameraDirection.vertical
            //"iPad Pro 13-inch (7th generation, Wi-Fi)"
        case "iPad16,6":
            return CameraDirection.vertical
            //"iPad Pro 13-inch (7th generation, Wi-Fi + Cellular)"
        case "x86_64", "arm64":
            return CameraDirection.not
        default:
            return CameraDirection.not
        }
    }
}
