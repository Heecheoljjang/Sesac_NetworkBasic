//
//  LottoViewController.swift
//  Sesac_NetworkBasic
//
//  Created by HeecheolYoon on 2022/07/28.
//

import UIKit

import Alamofire
import SwiftyJSON

class LottoViewController: UIViewController {
    
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet var numberLabel: [UILabel]!
    @IBOutlet weak var bonusNumLabel: UILabel!
    
    var lottoPickerView = UIPickerView()
    
    let numberList: [Int]  = Array(1...1026).reversed()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        numberTextField.textContentType = .oneTimeCode
        
        //키보드 안올라오게
        numberTextField.inputView = lottoPickerView
        
        //커서 안보이게하면 버튼처럼 사용할 수 있음.
        numberTextField.tintColor = .clear
        
        
        lottoPickerView.dataSource = self
        lottoPickerView.delegate = self
        numberTextField.delegate = self
        
        // 처음에는 가장 최근 회차의 번호를 띄움
        requestLotto(number: 1026)
        
    }
    
    
}

extension LottoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberList.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        requestLotto(number: numberList[row])
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])회차"
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return CGFloat(200)
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return CGFloat(44)
    }

    func requestLotto(number: Int) {
    
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(number)"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
        
                for i in 0...5 {
                    self.numberLabel[i].text = json["drwtNo\(i+1)"].stringValue
                }
                self.bonusNumLabel.text = json["bnusNo"].stringValue
                
                let date = json["drwNoDate"].stringValue
                let round = json["drwNo"].intValue
                
                self.numberTextField.text = date + ", \(round)회차"
            case .failure(let error):
                print(error)
            }
        }
    }
}
extension LottoViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        numberTextField.isUserInteractionEnabled = false
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        numberTextField.isUserInteractionEnabled = true
    }
}
