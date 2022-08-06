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
    
    //네트워크 요청할 시작 페이지 넘거
    var startPage = 1
    var totalCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        
        imageCollectionView.prefetchDataSource = self
        
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
    func fetchImage(query: String) {
        ImageSearchAPIManager.shared.fetchImageData(query: query, startPage: startPage) { totalCount, list in
            self.totalCount = totalCount
            self.imageList.append(contentsOf: list)
            
            DispatchQueue.main.async {
                self.imageCollectionView.reloadData()
            }
        }
    }
}

extension ImageSearchViewController: UISearchBarDelegate {
    
    //검색버튼 클릭시 실행. 검색 단어가 바뀔 수 있음.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let text = searchBar.text {
            imageList.removeAll()
            startPage = 1
            
            //스크롤 맨위로 안올려주면 중간에 다시 검색하면 스크롤 위치 그대로
            //imageCollectionView.scrollToItem(at: <#T##IndexPath#>, at: <#T##UICollectionView.ScrollPosition#>, animated: <#T##Bool#>)
            
            fetchImage(query: text)
        }
    }
    
    //취소버튼 눌렀을때 실행. 전부다 clear시키고 싶을때
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        imageList.removeAll()
        imageCollectionView.reloadData()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    //서치바에 커서가 깜빡이기 시작할때 실행
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
}


//페이지네이션 세번째 방법 - 용량이 큰 이미지를 다운받아 셀에 보여주려고 하는 경우에 효과적
//화면에 셀이 보이기전에 필요한 리소스들을 미리 받을 수도 있고, 필요없다면 데이터를 취소할 수도 있음.
//iOS 10이상, 스크롤 성능 향상됨.
extension ImageSearchViewController: UICollectionViewDataSourcePrefetching {
    
    //셀이 화면에 보이기 직전에 필요한 리소스를 미리 다운받는 기능
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("=====\(indexPaths)=====")
        
        for indexPath in indexPaths {
            if imageList.count - 1 == indexPath.item && imageList.count < totalCount {
                startPage += 30
                fetchImage(query: searchBar.text!)
            }
        }
    }
    
    //취소: 직접 취소하는 기능을 구현해야함.
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("=====취소: \(indexPaths)=====")

    }
    
    
}

extension ImageSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        
        let imageURL = URL(string: imageList[indexPath.item].thumbnailImage)
        print("ddd \(imageList)")
        
        cell.myImageView.kf.setImage(with: imageURL)
        
        return cell
    }
    //페이지네이션 첫번째 방법 - 컬렉션뷰가 특정 셀을 그리려는 시점에 호출되는 메서드
    //마지막 셀에 사용자가 위치해있는지 명확하게 확인하기가 어려움
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    //두번째방법 - UIScrollViewDelegateProtocol사용
    //테이블뷰와 컬렉션뷰는 스크롤뷰를 상속받고있어서, 스크롤뷰 프로토콜을 사용할 수 있음
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        //scrollView.ContentSize.height 활용
//        print(scrollView.contentOffset) // 디바이스 기준으로 가장 끝쪽을 확인 scrollView.contentOffset.y
//    }
    
    
}
