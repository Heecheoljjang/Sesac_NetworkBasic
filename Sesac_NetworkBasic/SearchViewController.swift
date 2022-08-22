//
//  SearchViewController.swift
//  Sesac_NetworkBasic
//
//  Created by HeecheolYoon on 2022/07/27.
//

import UIKit
import Alamofire
import SwiftyJSON
import JGProgressHUD
import RealmSwift

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
    
    let hud = JGProgressHUD()
    
    let localRealm = try! Realm()
    
    var tasks: MovieData?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchTableView.reloadData()
    }

    func requestBoxOffice(text: String) {
        
        
        list.removeAll()
    
        if localRealm.object(ofType: MovieData.self, forPrimaryKey: text) != nil {
            tasks = localRealm.object(ofType: MovieData.self, forPrimaryKey: text)
            searchTableView.reloadData()
        } else {
            hud.textLabel.text = "Loading"
            hud.show(in: view)
            
            let url = "\(EndPoint.boxOfficeURL)key=\(APIKey.BOXOFFICE)&targetDt=\(text)"
            
            AF.request(url, method: .get).validate().responseData { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    //print(json)
                    
                    let movieData = List<Movie>()
                    for movie in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                        let movieNm = movie["movieNm"].stringValue
                        let openDt = movie["openDt"].stringValue
                        let audiAcc = movie["audiAcc"].stringValue
                        let rank = movie["rank"].stringValue

                        let data = Movie(rank: rank, movieTitle: movieNm, releaseDate: openDt, totalCount: audiAcc)
                        movieData.append(data)
                    }
                    let task = MovieData(boxofficeList: movieData, objectId: text)

                    try! self.localRealm.write {
                        self.localRealm.add(task) //실질적으로 create
                        self.tasks = self.localRealm.object(ofType: MovieData.self, forPrimaryKey: text)
                        print(self.tasks)
                        self.searchTableView.reloadData()
                        print(self.localRealm.configuration.fileURL!)
                    }

                    //self.searchTableView.reloadData()
                    self.hud.dismiss()
                    
                case .failure(let error):
                    print(error)
                    self.hud.dismiss()
                    
                    //시뮬레이터 실패 테스트 -> 맥의 환경 따라감
                    
                }
            }
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tasks = tasks else {
            return 10
        }

        return tasks.boxofficeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        guard let tasks = tasks else { return UITableViewCell() }

        
        cell.rankLabel.text = tasks.boxofficeList[indexPath.row].rank
        cell.titleLabel.text = tasks.boxofficeList[indexPath.row].movieTitle
        cell.titleLabel.font = .boldSystemFont(ofSize: 22)
        cell.releaseDate.text = tasks.boxofficeList[indexPath.row].releaseDate
        cell.totalCount.text = tasks.boxofficeList[indexPath.row].totalCount
        
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
        if let text = searchBar.text {
            requestBoxOffice(text: text)
        }
    }
}
