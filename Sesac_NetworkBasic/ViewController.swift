//
//  ViewController.swift
//  Sesac_NetworkBasic
//
//  Created by HeecheolYoon on 2022/07/28.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaultsHelper.shared.nickname = "고래밥"
        
        title = UserDefaultsHelper.shared.nickname

    }
    @IBAction func tapBtn(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: WebViewController.identity) as? WebViewController else { return }
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
}
