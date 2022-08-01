//
//  TranslateViewController.swift
//  Sesac_NetworkBasic
//
//  Created by HeecheolYoon on 2022/07/28.
//

import UIKit

class TranslateViewController: UIViewController {
    
    @IBOutlet weak var userInputTextView: UITextView!
    
    let textViewPlaceholderText = "번역하고 싶은 문장을 작성해보세요."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userInputTextView.delegate = self
        
        userInputTextView.text = textViewPlaceholderText
        userInputTextView.textColor = .lightGray
        
        userInputTextView.font = .boldSystemFont(ofSize: 20)
        
//        userInputTextView.dataDetectorTypes = .calendarEvent
//        userInputTextView.text = "07/30/2022"
//        userInputTextView.isEditable = false
        
        let attributedString = NSMutableAttributedString(string: "안녕")
        let attachment = NSTextAttachment(image: UIImage(named: "겨울왕국2")!)
        attachment.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        attributedString.append(NSAttributedString(attachment: attachment))
        userInputTextView.attributedText = attributedString
        
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
