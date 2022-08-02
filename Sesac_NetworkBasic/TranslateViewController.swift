//
//  TranslateViewController.swift
//  Sesac_NetworkBasic
//
//  Created by HeecheolYoon on 2022/07/28.
//

import UIKit

import Alamofire
import SwiftyJSON

class TranslateViewController: UIViewController {
    
    @IBOutlet weak var userInputTextView: UITextView!
    @IBOutlet weak var resultTextView: UITextView!
    
    let textViewPlaceholderText = "번역하고 싶은 문장을 작성해보세요."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userInputTextView.delegate = self
        
        userInputTextView.text = textViewPlaceholderText
        userInputTextView.textColor = .lightGray
        
        userInputTextView.font = .boldSystemFont(ofSize: 20)

        
        //requestTranslatedData(text: userInputTextView.text)
        resultTextView.text = ""
        
    }
    
    func requestTranslatedData(text: String) {
        let url = EndPoint.translateURL
        
        let parameter = ["source": "ko", "target": "en", "text": text]
        
        // 타입 어노테이션해야함 String: STring으로 돼있음. 그리고 HTTPHeader로쓴느거 조심
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
        
        AF.request(url, method: .post, parameters: parameter, headers: header).validate(statusCode: 200..<400).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                let statusCode = response.response?.statusCode ?? 500
                
                if statusCode == 200 {
                    self.resultTextView.text = json["message"]["result"]["translatedText"].stringValue
                } else {
                    self.userInputTextView.text = json["errorMessage"].stringValue
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    @IBAction func tapTranslateButton(_ sender: UIButton) {
        requestTranslatedData(text: userInputTextView.text!)
    }
}
extension TranslateViewController: UITextViewDelegate {
    
    // 텍스트뷰의 텍스트가 변할때마다 호출. 한글자한글자마다
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text.count, textView.text)
    }
    
    //did와 should의 차이는?
    //편집이 시작될때. 커서가 보이는ㄴ 순간
    //텍스트뷰 글자: 플레이스홀더랑 글자가 같으면 clear하고, 색
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("begin")
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    //편집이 끝났을때. 커서가 없어지는 순간 -> 따로 구현불가능 (다른 요소를 클릭)
    //텍스트뷰 글자: 사용자가 아무 글자도 안썼으면 플레이스 홀더 글자보이게해
    func textViewDidEndEditing(_ textView: UITextView) {
        print("end")
        if textView.text == "" {
            textView.text = textViewPlaceholderText
            textView.textColor = .lightGray
        }
    }
}
