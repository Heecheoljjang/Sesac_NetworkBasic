//
//  BeerListViewController.swift
//  Sesac_NetworkBasic
//
//  Created by HeecheolYoon on 2022/08/03.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class BeerListViewController: UIViewController {

    @IBOutlet weak var beerListTableView: UITableView!
    
    var list: [BeerModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        beerListTableView.delegate = self
        
        beerListTableView.register(UINib(nibName: BeerListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: BeerListTableViewCell.identifier)
        
        requestBeerList()
        
    }
    
    func requestBeerList() {
        
        AF.request(EndPoint.beerListURL, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                
               
                
            case .failure(let error):
                print(error)
            }
        }
    }
}


extension BeerListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BeerListTableViewCell.identifier) as? BeerListTableViewCell else { return UITableViewCell() }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(136)
    }
    
    
}
