//
//  ImageSearchViewController.swift
//  Sesac_NetworkBasic
//
//  Created by HeecheolYoon on 2022/08/03.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

class ImageSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var imageList: [ImageModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        
        imageCollectionView.register(UINib(nibName: ImageCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        
        let width = view.frame.size.width - (4 * spacing)
        
        layout.itemSize = CGSize(width: width / 3, height: (width / 3) * 1.4)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        imageCollectionView.collectionViewLayout = layout
        
    }
    
    //fetchImage, requestImage, callRequestImage, getImage.. 통신할때 이름 -> 서버의 응답값에 따라 네이밍을 설정해주기도함.
    func fetchImage(text: String) {
        
        imageList.removeAll()
        
        let text = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        // 다음페이지로 간다면 start를 21로 바꿔주어야함.
        let url = EndPoint.imageSearchURL + "query=\(text)&display=30&start=1"
        
        //let parameter = []
        
        // 타입 어노테이션해야함 String: STring으로 돼있음. 그리고 HTTPHeader로쓴느거 조심
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
        
        AF.request(url, method: .get, headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                for image in json["items"].arrayValue {
                    
                    let imageURL = image["thumbnail"].stringValue
                    
                    self.imageList.append(ImageModel(thumbnailImage: imageURL))
                }
                print(self.imageList)
                print(self.imageList.count)
                self.imageCollectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ImageSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchImage(text: searchBar.text!)
    }
}

extension ImageSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        
        let imageURL = URL(string: imageList[indexPath.item].thumbnailImage)
        cell.myImageView.kf.setImage(with: imageURL)
        
        return cell
    }
    
}
