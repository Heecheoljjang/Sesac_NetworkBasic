import Foundation
import UIKit

/*
 ~~~protocol
 */

//프로토콜은 규약이자 필요한 요소를 명세만 할 뿐, 실질적인 구현부는 작성하지않는다.
//실질적인 구현은 프로토콜을 채택, 준수한 타입이 구현합니다.
//@objc optional -> 선택적 요청(Optional Requirement
//프로토콜 프로퍼티, 프로토콜 메서드
// 만약 get만 명시했다면, get기능만 최소한 구현되어 있으면 된다. 그래서 필요하다면 set도 구현해도 괜찮음.
// get으로 쓴다면 변경불가능하게 let으로 선언가능
// set까지 썼다면 let으로 사용불가능

@objc protocol ViewPresentableProtocol {
    
    var navigationTitleString: String { get set }
    
    var backgroundColor: UIColor { get }
    
    static var identifier: String { get }
    
    @objc optional func configureView()
    @objc optional func configureLabel()

}


/*
 ex. 테이블뷰
 */

@objc protocol heeTableViewProtocol {
    func numberOfRowsInSection() -> Int
    func cellForRowAt(indexPath: IndexPath) -> UITableViewCell
    @objc optional func didSelectRowAt()
}
