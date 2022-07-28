//
//  LottoViewController.swift
//  Sesac_NetworkBasic
//
//  Created by HeecheolYoon on 2022/07/28.
//

import UIKit

class LottoViewController: UIViewController {
    
    
    @IBOutlet weak var numberTextField: UITextField!
//    @IBOutlet weak var lottoPickerView: UIPickerView!
    
    var lottoPickerView = UIPickerView()
    
    let numberList: [Int]  = Array(1...1025).reversed()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //키보드 안올라오게
        numberTextField.inputView = lottoPickerView
        
        //커서 안보이게하면 버튼처럼 사용할 수 있음.
        numberTextField.tintColor = .clear
        
        
        lottoPickerView.dataSource = self
        lottoPickerView.delegate = self
        
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
        numberTextField.text = "\(numberList[row])회차"
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])회차"
    }
    
}
