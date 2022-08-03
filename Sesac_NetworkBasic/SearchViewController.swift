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
        
        let format = DateFormatter()
        format.dateFormat = "yyyyMMdd" // "yyyyMMdd" "YYYYMMdd" 둘은 차이있음.
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date() ) // to가 기준점이 되는 시간
        let dateResult = format.string(from: yesterday!)
        
        requestBoxOffice(text: dateResult)
    }

    func requestBoxOffice(text: String) {
        
        list.removeAll()
    

        let url = "\(EndPoint.boxOfficeURL)key=\(APIKey.BOXOFFICE)&targetDt=\(text)"
       
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                for movie in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    let movieNm = movie["movieNm"].stringValue
                    let openDt = movie["openDt"].stringValue
                    let audiAcc = movie["audiAcc"].stringValue
                    let rank = movie["rank"].stringValue

                    let data = BoxOfficeModel(movieTitle: movieNm, releaseDate: openDt, totalCount: audiAcc, rank: rank)


                    self.list.append(data)
                }

                self.searchTableView.reloadData()
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
        
        cell.rankLabel.text = "\(list[indexPath.row].rank)"
        cell.titleLabel.text = "제목: \(list[indexPath.row].movieTitle)"
        cell.titleLabel.font = .boldSystemFont(ofSize: 22)
        cell.releaseDate.text = "개봉 날짜: \(list[indexPath.row].releaseDate)"
        cell.totalCount.text = "관객수: \(list[indexPath.row].totalCount)"
        
        return cell
    }
    @objc func tapHeartBtn(sender: UIButton) {
        // check가 true면 꽉찬하트, false면 빈 하트
        // 여기서는 값만 바꿔주고, 뷰와 관련된 것은 cellForRowAt에서 하기
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        requestBoxOffice(text: searchBar.text!) // 옵셔널 바인딩, 8글자, 숫자, 날짜로 변경 시 유효한 형태의 값인지 등
    }
}
