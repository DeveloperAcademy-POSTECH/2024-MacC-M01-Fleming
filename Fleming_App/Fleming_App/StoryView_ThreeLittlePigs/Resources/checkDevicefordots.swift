//
//  checkDevicefordots.swift
//  Fleming_App
//
//  Created by 임유리 on 11/2/24.
//

import SwiftUI


struct checkDevice_fordots {
    @State private var deviceName: String = ""
    
//    var body: some View {
//        VStack {
////            Text("Device Name: \(deviceName)!!")
////            Text("!!")
//        }
//        .onAppear {
//            self.deviceName = self.getDeviceName()
//        }
//    }
    
    func getDeviceName() -> CameraDirection_fordots {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        
        guard let code = modelCode else { return CameraDirection_fordots.not }
        
        return mapToDevice(identifier: code)
    }
    
    func mapToDevice(identifier: String) -> CameraDirection_fordots { //확인 이후 if로 변경예정
        switch identifier {
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
            return CameraDirection_fordots.horizontal
        case "iPad3,1", "iPad3,2", "iPad3,3":
            return CameraDirection_fordots.horizontal
        case "iPad3,4", "iPad3,5", "iPad3,6":
            return CameraDirection_fordots.horizontal
        case "iPad4,1", "iPad4,2", "iPad4,3":
            return CameraDirection_fordots.horizontal
        case "iPad5,3", "iPad5,4":
            return CameraDirection_fordots.horizontal
        case "iPad6,11", "iPad6,12":
            return CameraDirection_fordots.horizontal
        case "iPad7,5", "iPad7,6":
            return CameraDirection_fordots.horizontal
        case "iPad11,3", "iPad11,4":
            return CameraDirection_fordots.horizontal
        case "iPad7,11", "iPad7,12":
            return CameraDirection_fordots.horizontal
        case "iPad11,6", "iPad11,7":
            return CameraDirection_fordots.horizontal
        case "iPad12,1", "iPad12,2":
            return CameraDirection_fordots.horizontal
        case "iPad13,18", "iPad13,19":
            return CameraDirection_fordots.vertical
            //"iPad 10"
        case "iPad13,1", "iPad13,2":
            return CameraDirection_fordots.horizontal
        case "iPad13,16", "iPad13,17":
            return CameraDirection_fordots.horizontal
        case "iPad2,5", "iPad2,6", "iPad2,7":
            return CameraDirection_fordots.horizontal
        case "iPad4,4", "iPad4,5", "iPad4,6":
            return CameraDirection_fordots.horizontal
        case "iPad4,7", "iPad4,8", "iPad4,9":
            return CameraDirection_fordots.horizontal
        case "iPad5,1", "iPad5,2":
            return CameraDirection_fordots.horizontal
        case "iPad11,1", "iPad11,2":
            return CameraDirection_fordots.horizontal
        case "iPad14,1", "iPad14,2":
            return CameraDirection_fordots.horizontal
        case "iPad6,3", "iPad6,4":
            return CameraDirection_fordots.horizontal
        case "iPad6,7", "iPad6,8":
            return CameraDirection_fordots.horizontal
        case "iPad7,1", "iPad7,2":
            return CameraDirection_fordots.horizontal
        case "iPad7,3", "iPad7,4":
            return CameraDirection_fordots.horizontal
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":
            return CameraDirection_fordots.horizontal
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":
            return CameraDirection_fordots.horizontal
        case "iPad8,9", "iPad8,10":
            return CameraDirection_fordots.horizontal
        case "iPad8,11", "iPad8,12":
            return CameraDirection_fordots.horizontal
        case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7":
            return CameraDirection_fordots.horizontal
        case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11":
            return CameraDirection_fordots.horizontal
        case "iPad14,3", "iPad14,4":
            return CameraDirection_fordots.vertical
            //"iPad Pro 11-inch (6th generation)"
        case "iPad14,5", "iPad14,6":
            return CameraDirection_fordots.vertical
            //"iPad Pro 12.9-inch (6th generation)"
        case "iPad14,10", "iPad14,11":
            return CameraDirection_fordots.vertical
        case "iPad14,8", "iPad14,9":
            return CameraDirection_fordots.horizontal
        case "iPad16,5":
            return CameraDirection_fordots.vertical
            //"iPad Pro 13-inch (7th generation, Wi-Fi)"
        case "iPad16,6":
            return CameraDirection_fordots.vertical
            //"iPad Pro 13-inch (7th generation, Wi-Fi + Cellular)"
        case "x86_64", "arm64":
            return CameraDirection_fordots.not
        default:
            return CameraDirection_fordots.not
        }
    }
}

//enum CameraDirection { 
//    case vertical
//    case horizontal
//    case not
//
//    func calculate() -> CGPoint {
//        switch self {
//        case .vertical:
//            <#code#>
//        case .horizontal: //변동해야함
//            <#code#>
//        case .not:
//            break
//        }
//    }
//}



//"Model Identifiers: iPad13,18", "iPad13,19"
//iPad Pro 12.9인치 (6세대)
//Model Identifiers: "iPad14,5", "iPad14,6"
//iPad Pro 11인치 (6세대)
//Model Identifiers: "iPad14,3", "iPad14,4"


//public enum iPadType: String {
//    case iPad2 = "iPad 2"
//    case iPad3 = "iPad 3"
//    case iPad4 = "iPad 4"
//    case iPadAir = "iPad Air"
//    case iPadAir2 = "iPad Air 2"
//..... 이런 식으로
//public static func getType(for identifier: String) -> iPadType? {
//        if ["iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4"].contains(identifier) {
//            return .iPad2
//        } else if ["iPad3,1", "iPad3,2", "iPad3,3"].contains(identifier) {
//            return .iPad3
//        } else if ["iPad3,4", "iPad3,5", "iPad3,6"].contains(identifier) {
//            return .iPad4
