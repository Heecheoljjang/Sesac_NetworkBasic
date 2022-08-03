//
//  BeerListTableViewCell.swift
//  Sesac_NetworkBasic
//
//  Created by HeecheolYoon on 2022/08/03.
//

import UIKit

class BeerListTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: BeerListTableViewCell.self)

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var beerImageView: UIImageView!
    
    
}
