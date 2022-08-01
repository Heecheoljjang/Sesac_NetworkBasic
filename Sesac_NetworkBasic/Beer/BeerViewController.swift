//
//  BeerViewController.swift
//  Sesac_NetworkBasic
//
//  Created by HeecheolYoon on 2022/08/01.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

class BeerViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var contributedLabel: UILabel!
    @IBOutlet weak var firstBrewedLabel: UILabel!
    @IBOutlet weak var foodPairingLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beerImageView.contentMode = .scaleToFill
        
        requestBeerInfo()
       
    }
    func requestBeerInfo() {
    
        let url = "https://api.punkapi.com/v2/beers/random"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                //이름 레이블
                self.nameLabel.text = json[0]["name"].stringValue
                print(json["name"])
                //이미지
                let url = URL(string: json[0]["image_url"].stringValue)
                self.beerImageView.kf.setImage(with: url)
                // contributed
                self.contributedLabel.text = "Contributed by " + json[0]["contributed_by"].stringValue
                //첫 브루
                self.firstBrewedLabel.text = "First Brewed: " + json[0]["first_brewed"].stringValue
                //곁들여먹는 음식
                self.foodPairingLabel.text = "Food Pairing: " + json[0]["food_pairing"][0].stringValue
                //설명
                self.detailLabel.text = "Detail: " + json[0]["description"].stringValue
                
            case .failure(let error):
                print(error)
            }
        }
    }
    @IBAction func tapChangeButton(_ sender: UIButton) {
        
        requestBeerInfo()
    }
    
}
