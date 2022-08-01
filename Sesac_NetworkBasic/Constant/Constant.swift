//
//  Constant.swift
//  Sesac_NetworkBasic
//
//  Created by HeecheolYoon on 2022/08/01.
//

import Foundation
//
//enum StoryboardName {
//    case Main
//    case Search
//    case Setting
//}

struct StoryboardName {
    
    //이걸쓰면 열거형과 차이가 거의 없어지는데 private쓰기 귀찮을때가ㅣ이씅ㅁ
    private init() {
        
    }
    
    static let main = "Main"
    static let search = "Search"
    static let setting = "Setting"
}
//
//enum StoryboardName {
//    static let main = "Main"
//    static let search = "Search"
//    static let setting = "Setting"
//}

enum FontName {
    static let title = "SanFransisco"
    static let body = "SanFransisco"
    static let caption = "Apple"
}
