//
//  ListTableViewCell.swift
//  Sesac_NetworkBasic
//
//  Created by HeecheolYoon on 2022/07/27.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    static let identifier = "ListTableViewCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var totalCount: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
}
