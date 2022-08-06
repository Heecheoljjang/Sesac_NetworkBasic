//
//  ImageSearchAPIManager.swift
//  Sesac_NetworkBasic
//
//  Created by HeecheolYoon on 2022/08/05.
//

import Foundation

import Alamofire
import SwiftyJSON

//클래스 싱글톤 패턴 vs 구조체 싱글턴 패턴
class ImageSearchAPIManager {
    
    //singleton
    static let shared = ImageSearchAPIManager()
    
    private init() {}
    
    typealias completionHandler = (Int, [ImageModel]) -> Void
    
    //클로저가 밖에서 사용될예정이기때문에 @escaping
    func fetchImageData(query: String, startPage: Int, completionHandler: @escaping completionHandler) {
        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        // 다음페이지로 간다면 start를 21로 바꿔주어야함.
        let url = EndPoint.imageSearchURL + "query=\(text)&display=30&start=\(startPage)"
        
        //let parameter = []
        
        // 타입 어노테이션해야함 String: STring으로 돼있음. 그리고 HTTPHeader로쓴느거 조심
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
        
        AF.request(url, method: .get, headers: header).validate().responseJSON(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                let totalCount = json["total"].intValue
                
                //map을 이용해서 배열로 만들어보기
                let list = json["items"].arrayValue.map { ImageModel(thumbnailImage: $0["link"].stringValue)}
                

//                for image in json["items"].arrayValue {
//
//                    let imageURL = image["thumbnail"].stringValue
//
//                    self.imageList.append(ImageModel(thumbnailImage: imageURL))
//                }
                
                completionHandler(totalCount, list)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
