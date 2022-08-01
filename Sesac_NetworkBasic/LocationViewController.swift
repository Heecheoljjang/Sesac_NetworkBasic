//
//  LocationViewController.swift
//  Sesac_NetworkBasic
//
//  Created by HeecheolYoon on 2022/07/29.
//

import UIKit

class LocationViewController: UIViewController {
    

    @IBOutlet weak var notiBtn: UIButton!
    
    // Notification 1
    let notificationCenter = UNUserNotificationCenter.current()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationViewController.reuseIdentifier
        
        requestAuthorization()
    }
    
    @IBAction func notificationBtnClicked(_ sender: UIButton) {

        self.sendNotification()
    }
    
    // Notifiation 2. 권한요청
    func requestAuthorization() {
        
        //option에는 여러개가 들어있음.
        
        let authorizationOption = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        
        notificationCenter.requestAuthorization(options: authorizationOption) { success, error in
            
            //사용자가 허용했을때만 알림보냄
            if success {
                self.sendNotification()
            }
            
        }
        
    }
    //Notification 3. 권한 허용한 사용자에게 알림 요청(언제? 어떤 컨텐츠?)
    //iOS시스템에서 알림을 담당하기때문에 알림 등록하는 코드 필요.
    
    /*
     
     - 권한 허용 해야만 알림이 온다.
     - 권한 허용 문구 시스템적으로 최초 한 번만 뜬다.
     - 그래서 허용이 안 된ㄷ 경우 애플 설정으로 직접 유도하는 코드를 구성해야한다.
     
     - 기본적으로 알림은 포그라운드에서 수신되지않음.
     - 로컬 알림에서는 60초 이상으로 설정해야 반복 가능 / 개수 제한 64개 -> 기준 찾아보기/ 커스텀 사운드 30초 제한
     
     
     1. 뱃지제거? -> appdelegate에서 해결
     2. 노티 제거? -> 노티의 유효기간은 기본적으로 한달정도 -> 앱마다 다르지만 런치스크린에서 지울수도있고, 뱃지 지울떄 지울수도있음. 포그라운드에서 지울떄도있으
     3. 포그라운드 수신 -> 열려있을때는 안오는게 디폴트값인듯 -> delegate 메서드로 해결해야함.
     
     +a
     - 노티는 앱 실행이 기본인데, 특정 노티를 클릭할 떄 특정 화면으로 가고 싶다면?
     - 포그라운드 수신을 특정 화면에서는 안받는 것처럼 특정 조건에 대해서만 포그라운드 수신을 하고싶다면?
     - iOS15 집중모드 등 5~6우선순위 존재그랫
     */
    
    
    func sendNotification() {
        let notificationContent = UNMutableNotificationContent()
        
        //어떤 컨텐츠
        notificationContent.title = "다마고치를 키워보세요."
        notificationContent.subtitle = "오늘 행운의 숫자는 \(Int.random(in: 1...100))"
        notificationContent.body = "저는 따끔따끔 다마고치입니다. 배고파요."
        notificationContent.badge = 40
        
        //언제 보낼지 -> 1. 시간 간격 2. 캘린더 3. 위치에 따라 설정 가능.
        //시간 간격은 60초이상 설정해야 반복가능, 반복안할거면 ㄱㅊ
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
//        var dateComponents = DateComponents()
//        dateComponents.minute = 15
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //let trigger = UNLocationNotificationTrigger
        
        //알림 요청
        //identifier가 동일하다면 알림이 쌓이지않고 이전 알림이 사라짐. 다르다면 스택으로 쌓임
        //만약 알림 관리할 필요가 없다면-> 알림 클릭하면 앱을 켜주는 정도
        //만약 알림 관리 할 필요가 있다면 -> +1, 고유이름, 규치 등
        //반복해서 오는 알림을 identifier를 따로 두고 싶다면 Date()를 이용하면됨
        let request = UNNotificationRequest(identifier: "\(Date())", content: notificationContent, trigger: trigger)
        
        //ios시스템에 전달해달라는 의미
        notificationCenter.add(request) // completion사용해도됨.
    }
}
