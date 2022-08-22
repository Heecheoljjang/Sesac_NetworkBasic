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
    
    let userDefaults = UserDefaults.standard
    
    var lottoPickerView = UIPickerView()
    let startDate = "2002-12-07"
    
    var numberList: [String] = []
    var latest = 1
    var roundArr: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        latest = getLatestDrw()
        roundArr = Array(1...latest).reversed()

        numberTextField.textContentType = .oneTimeCode
        
        //키보드 안올라오게
        numberTextField.inputView = lottoPickerView
        
        //커서 안보이게하면 버튼처럼 사용할 수 있음.
        numberTextField.tintColor = .clear
        
        //비워두기
        for label in numberLabel {
            label.text = ""
        }
        bonusNumLabel.text = ""
        
        lottoPickerView.dataSource = self
        lottoPickerView.delegate = self
        numberTextField.delegate = self
        
        // 처음에는 가장 최근 회차의 번호를 띄움
        requestLotto(number: latest)
        
    }
    
    
}

extension LottoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return roundArr.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        requestLotto(number: roundArr[row])
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(roundArr[row])회차"
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return CGFloat(200)
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return CGFloat(44)
    }

    func requestLotto(number: Int) {
        
        if userDefaults.array(forKey: "\(number)") != nil {
            print("이미있듬")
            print("\(userDefaults.array(forKey: "\(number)"))")
            numberList = userDefaults.array(forKey: "\(number)") as! [String]
            print(numberList)
            DispatchQueue.main.async {
                for i in 0..<self.numberLabel.count {
                    self.numberLabel[i].text = "\(self.numberList[i])"
                }
                self.bonusNumLabel.text = "\(self.numberList[6])"
//                self.numberTextField.text = date + ", \(round)회차"
                self.numberTextField.text = self.numberList[7] + ", \(self.numberList[8])회차"
            }
        } else {
            print("없음")
            var tempArr: [String] = []
            let url = "\(EndPoint.lottoURL)&drwNo=\(number)"
            AF.request(url, method: .get).validate().responseJSON(queue: .global()) { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    DispatchQueue.main.async {
                        for i in 0...5 {
                            self.numberLabel[i].text = json["drwtNo\(i+1)"].stringValue
                            tempArr.append(json["drwtNo\(i+1)"].stringValue)
                            print(tempArr)
                        }
                        self.bonusNumLabel.text = json["bnusNo"].stringValue
                        tempArr.append(json["bnusNo"].stringValue)
                        
                        let date = json["drwNoDate"].stringValue
                        tempArr.append(json["drwNoDate"].stringValue)
                        let round = json["drwNo"].intValue
                        tempArr.append(json["drwNo"].stringValue)
                        
                        self.numberTextField.text = date + ", \(round)회차"
                        self.userDefaults.set(tempArr, forKey: "\(number)")
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getLatestDrw() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.date(from: startDate)
        let today = dateFormatter.date(from: dateFormatter.string(from: Date()))
        
        let interval = Int(today!.timeIntervalSince(startDate!)) / 86400
        let latest = interval / 7
        
        return latest
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
