//
//  GoodVC.swift
//  Term Project Jeju
//
//  Created by KPUGAME on 24/05/2019.
//  Copyright © 2019 KPUGAME. All rights reserved.
//

import UIKit
import MapKit

class GoodVC: UIViewController, XMLParserDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tbData : UITableView!
    
    // feed 데이터를 저장하는 mutable array
    static var posts = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return GoodVC.posts.count
    }
    
    // 테이블 뷰 셀의 내용은 title과 subtitle을 posts 배열의 원소(사전)에서 title과 date에 해당하는 value로 설정
    func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let area = (GoodVC.posts.object(at: indexPath.row) as AnyObject).value(forKey: "area") as! NSString as String
        let adres = (GoodVC.posts.object(at: indexPath.row) as AnyObject).value(forKey: "adres") as! NSString as String
        let induty = (GoodVC.posts.object(at: indexPath.row) as AnyObject).value(forKey: "induty") as! NSString as String
        
        cell.textLabel?.text = area + " " + adres
        
        cell.detailTextLabel?.text = induty
        
        return cell // as UITableViewCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToMapView"
        {
            if let mapVC = segue.destination as? GoodMapVC
            {
                let posy = (GoodVC.posts.object(at: 0) as AnyObject).value(forKey: "posy") as! NSString as String
                let posx = (GoodVC.posts.object(at: 0) as AnyObject).value(forKey: "posx") as! NSString as String
                let lat = (posy as NSString).doubleValue
                let lon = (posx as NSString).doubleValue
                
                mapVC.initlocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                mapVC.posts = GoodVC.posts
            }
        }
    }
}
//    "area"/*시*/,          "adres"/*주소*/,          "appnPrdlstPc"/*지정품목 및 가격*/,    "bsnTime"/*영업 시간*/,
//    "dataContent"/*상세*/,  "dataTitle"/*업소명*/,     "hvofSttus"/*휴무 상태*/,           "induty"/*업종*/,
//    "posx"/*경도*/,         "posy"/*위도*/,           "regDate"/*등록일*/,                "telNo"/*전화번호*/
