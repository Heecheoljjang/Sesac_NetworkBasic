//
//  UserDefaultsHelper.swift
//  Sesac_NetworkBasic
//
//  Created by HeecheolYoon on 2022/08/01.
//

import Foundation

class UserDefaultsHelper {
    
    private init() {}
    
    // 싱글톤패턴은 자기 자신의 인스턴스를 타입 프로퍼티 형태로 가지고이씅.
    static let shared = UserDefaultsHelper()
    
    let userDefaults = UserDefaults.standard
    
    
    enum Key: String {
        case nickname
        case age
    }
    
    var nickname: String {
        get {
            return userDefaults.string(forKey: Key.nickname.rawValue) ?? "대장"
        }
        set {
            userDefaults.set(newValue, forKey: Key.nickname.rawValue)
        }
    }
    
    var age: Int {
        get {
            return userDefaults.integer(forKey: Key.age.rawValue) // 디폴트로 0이 들어가기 때문에 옵셔널 처리안해도됨
        }
        set {
            userDefaults.set(newValue, forKey: Key.age.rawValue)
        }
    }
}
