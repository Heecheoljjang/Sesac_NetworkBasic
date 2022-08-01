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

struct MyCell {
    var labelText: String
    var check: Bool = false
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    var navigationTitleString: String = ""
//
//    var backgroundColor: UIColor
//
//    static var identifier: String
//
    
    

    @IBOutlet weak var searchTableView: UITableView!
    
    var myList = [MyCell(labelText: "바보"), MyCell(labelText: "1"), MyCell(labelText: "2"), MyCell(labelText: "3"), MyCell(labelText: "4"), MyCell(labelText: "5"), MyCell(labelText: "6"), MyCell(labelText: "7"), MyCell(labelText: "8"), MyCell(labelText: "바보"), MyCell(labelText: "바보"), MyCell(labelText: "바보"), MyCell(labelText: "바보"), MyCell(labelText: "9"), MyCell(labelText: "10"), MyCell(labelText: "11"), MyCell(labelText: "12"), MyCell(labelText: "13"), MyCell(labelText: "14"), MyCell(labelText: "15"), MyCell(labelText: "16"), MyCell(labelText: "17"), MyCell(labelText: "바보"), MyCell(labelText: "바보"), MyCell(labelText: "바보"), MyCell(labelText: "바보"), MyCell(labelText: "바보"), MyCell(labelText: "18"), MyCell(labelText: "19"), MyCell(labelText: "20"), MyCell(labelText: "21"), MyCell(labelText: "22"), MyCell(labelText: "23"), MyCell(labelText: "24"), MyCell(labelText: "25")] {
        didSet {
            searchTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //연결고리 작업: 테이블뷰가 해야 할 역할을 뷰컨트롤러에게 요청
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        //테이블뷰가 사용할 테이블뷰셀 등록(XIB를 사용할떄 작성)
        //xib: xml interface builder <= 예전에는 Nib사용
        searchTableView.register(UINib(nibName: ListTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ListTableViewCell.identifier)
        
    }
//    func configureView() {
//        searchTableView.backgroundColor = .clear
//        searchTableView.separatorColor = .clear
//        searchTableView.rowHeight = 60
//    }
    
    func configureLabel() {
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = "HI"
        cell.titleLabel.font = .boldSystemFont(ofSize: 22)
        cell.myBtn.tag = indexPath.row // 태그를 이용해서 리스트 위치를 알아낼 것이기때문에 필요
        
        cell.myBtn.addTarget(self, action: #selector(tapHeartBtn), for: .touchUpInside)
        
        let img = myList[indexPath.row].check ? "heart.fill" : "heart"
        cell.myBtn.setImage(UIImage(systemName: img), for: .normal)
        
        return cell
    }
    @objc func tapHeartBtn(sender: UIButton) {
        // check가 true면 꽉찬하트, false면 빈 하트
        // 여기서는 값만 바꿔주고, 뷰와 관련된 것은 cellForRowAt에서 하기
        myList[sender.tag].check = !myList[sender.tag].check
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }

}
