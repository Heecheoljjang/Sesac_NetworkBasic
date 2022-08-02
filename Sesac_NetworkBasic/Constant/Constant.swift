//
//  Constant.swift
//  Sesac_NetworkBasic
//
//  Created by HeecheolYoon on 2022/08/01.
//

import Foundation

struct APIKey {
    static let BOXOFFICE = "e5ec1411ff0903bf129599d208aff1c1"
    static let NAVER_ID = "JPn2BexzHtawtjBLviCv"
    static let NAVER_SECRET = "z4H3ty26JR"
    static let OPENWEATHER = "4af5cb37399a98438645cb803764aa97"
}

struct EndPoint {
    static let boxOfficeURL = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?"
    static let lottoURL = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber"
    static let translateURL = "https://openapi.naver.com/v1/papago/n2mt"
}

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
