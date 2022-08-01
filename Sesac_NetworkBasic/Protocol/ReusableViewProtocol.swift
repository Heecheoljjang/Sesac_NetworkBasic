//
//  ReusableViewProtocol.swift
//  Sesac_NetworkBasic
//
//  Created by HeecheolYoon on 2022/08/01.
//

import Foundation
import UIKit

protocol ReusableViewProtocol {
    static var reuseIdentifier: String { get }
}

extension UIViewController: ReusableViewProtocol {
    
    static var reuseIdentifier: String {
            return String(describing: self)
    }
}

extension UITableViewCell: ReusableViewProtocol {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}
