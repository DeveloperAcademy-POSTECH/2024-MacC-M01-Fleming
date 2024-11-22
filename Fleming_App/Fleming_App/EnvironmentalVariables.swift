//
//  EnvironmentalVariables.swift
//  Fleming_App
//
//  Created by Leo Yoon on 11/21/24.
//
import SwiftUI

class SettingVariables: ObservableObject {
    // 볼륨 크기 조절용 변수들
    @Published var volumeBackground: Float {
        didSet { UserDefaults.standard.set(volumeBackground, forKey: "volumeBackground") }
    }
    @Published var volumeTTS: Float {
        didSet { UserDefaults.standard.set(volumeTTS, forKey: "volumeTTS") }
    }
    
    // 언어 설정 조절용 변수들
    //    @Published var languageSetting: Bool = false // false: 영어, true: 한국어
    @Published var selectedLanguage: String {
        didSet {
            UserDefaults.standard.set([selectedLanguage], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            reloadAppBundle()
        }
    }
    
    init() {
        
        // [볼륨 기능들] UserDefaults에서 저장된 값을 불러오거나, 기본값 설정
        self.volumeBackground = UserDefaults.standard.object(forKey: "volumeBackground") != nil ? UserDefaults.standard.float(forKey: "volumeBackground") : 0.5
        self.volumeTTS = UserDefaults.standard.object(forKey: "volumeTTS") != nil ? UserDefaults.standard.float(forKey: "volumeTTS") : 0.5
        
        // [언어 설정값] UserDefaults에서 저장된 값을 불러오거나, 기본값 설정
        let currentLanguage = UserDefaults.standard.stringArray(forKey: "AppleLanguages")?.first ?? "en"
        self.selectedLanguage = currentLanguage
        reloadAppBundle() // 초기 로드 시 번들 설정
    }
    
    func reloadAppBundle() {
        // 번들 동적 변경
        Bundle.setLanguage(selectedLanguage)
        
        // 강제로 뷰 새로고침
        DispatchQueue.main.async {
            self.objectWillChange.send()
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                // window를 사용하여 필요한 작업 수행
            }
        }
    }
}

// 언어를 동적으로 로드하는 Bundle의 확장
extension Bundle {
    private static var bundleKey: UInt8 = 0
    
    class func setLanguage(_ language: String) {
        if let path = Bundle.main.path(forResource: language, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            objc_setAssociatedObject(Bundle.main, &bundleKey, bundle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        } else {
            objc_setAssociatedObject(Bundle.main, &bundleKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    static func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let bundle = objc_getAssociatedObject(Bundle.main, &bundleKey) as? Bundle {
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        } else {
            return Bundle.main.localizedString(forKey: key, value: value, table: tableName)
        }
    }
}
