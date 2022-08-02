//
//  SearchViewController.swift
//  Sesac_NetworkBasic
//
//  Created by HeecheolYoon on 2022/07/27.
//

import UIKit
import Alamofire
import SwiftyJSON

/*
 Swift Protocol
 - Delegate
 - DataSource
 
 1. 왼팔 / 오른팔
 2. 테이블뷰 아웃렛 연결
 3. 1 + 2 
 
 */

/*
 각 json value -> list -> tableview 갱신
 서버의 응답이 몇개인지 모를땐?
 */

struct MyCell {
    var labelText: String
    var check: Bool = false
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var list: [BoxOfficeModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //연결고리 작업: 테이블뷰가 해야 할 역할을 뷰컨트롤러에게 요청
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        //테이블뷰가 사용할 테이블뷰셀 등록(XIB를 사용할떄 작성)
        //xib: xml interface builder <= 예전에는 Nib사용
        searchTableView.register(UINib(nibName: ListTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ListTableViewCell.identifier)
        
        searchBar.delegate = self
        
        requestBoxOffice(text: "20220701")
    }

    func requestBoxOffice(text: String) {
        
        list.removeAll()
    
        let url = "\(EndPoint.boxOfficeURL)key=\(APIKey.BOXOFFICE)&targetDT=20220202"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                for movie in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    let movieNm = movie["movieNm"].stringValue
                    let openDt = movie["openDt"].stringValue
                    let audiAcc = movie["audiAcc"].stringValue
                    
                    let data = BoxOfficeModel(movieTitle: movieNm, releaseDate: openDt, totalCount: audiAcc)
                    
                    
                    self.list.append(data)
                }
                
                self.searchTableView.reloadData()
                print(self.list)
            case .failure(let error):
                print(error)
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = "\(list[indexPath.row].movieTitle): \(list[indexPath.row].releaseDate)"
        cell.titleLabel.font = .boldSystemFont(ofSize: 22)
        
        
        
        return cell
    }
    @objc func tapHeartBtn(sender: UIButton) {
        // check가 true면 꽉찬하트, false면 빈 하트
        // 여기서는 값만 바꿔주고, 뷰와 관련된 것은 cellForRowAt에서 하기
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        requestBoxOffice(text: searchBar.text!) // 옵셔널 바인딩, 8글자, 숫자, 날짜로 변경 시 유효한 형태의 값인지 등
    }
}
