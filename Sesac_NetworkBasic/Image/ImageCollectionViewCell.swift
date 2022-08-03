//
//  ImageCollectionViewCell.swift
//  Sesac_NetworkBasic
//
//  Created by HeecheolYoon on 2022/08/03.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: ImageCollectionViewCell.self)

    @IBOutlet weak var myImageView: UIImageView!
    
    override func awakeFromNib() {
        myImageView.contentMode = .scaleToFill
    }
    
    
}
