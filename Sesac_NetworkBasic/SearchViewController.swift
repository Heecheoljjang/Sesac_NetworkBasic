//
//  SearchViewController.swift
//  Sesac_NetworkBasic
//
//  Created by HeecheolYoon on 2022/07/27.
//

import UIKit

/*
 Swift Protocol
 - Delegate
 - DataSource
 
 1. 왼팔 / 오른팔
 2. 테이블뷰 아웃렛 연결
 3. 1 + 2 
 
 */


class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //연결고리 작업: 테이블뷰가 해야 할 역할을 뷰컨트롤러에게 요청
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        //테이블뷰가 사용할 테이블뷰셀 등록(XIB를 사용할떄 작성)
        //xib: xml interface builder <= 예전에는 Nib사용
        searchTableView.register(UINib(nibName: ListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ListTableViewCell.identifier)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = "HI"
        cell.titleLabel.font = .boldSystemFont(ofSize: 22)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }

}
