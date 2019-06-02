//
//  GoodVC.swift
//  Term Project Jeju
//
//  Created by KPUGAME on 24/05/2019.
//  Copyright © 2019 KPUGAME. All rights reserved.
//

import UIKit
import MapKit

class PharmacyVC: UIViewController, XMLParserDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tbData : UITableView!
    
    var parser = XMLParser()
    
    // feed 데이터를 저장하는 mutable array
    static var posts = NSMutableArray()
    
    // title과 date 같은 feed 데이터를 저장하는 mutable dictionary
    var elements = NSMutableDictionary()
    var element = NSString()

    var url : String! = "http://data.jeju.go.kr/rest/nightpharmacy/getNightPharmacyList?serviceKey=7Z3e6MM%2BZVra4DYqS7dDT%2Bsfh%2Fw2JlIBVc4uE9Xc%2FEKVgineKHp9fvznQMmblhdNhsBaCa2S31NGHVGY2j9gLg%3D%3D&pageSize=1000"
    
    var parameters : [String] =
        ["adres"/*주소*/, "dataTitle"/*업소명*/, "la"/*위도*/, "lo"/*경도*/,
        "regDate"/*작성일*/, "remark"/*비고*/, "telNo"/*연락처*/]
    
    var datas : [String: NSMutableString] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beginParsing()
    }
    
    // parse 오브젝트 초기화하고 XMLParserDelegate로 설정하고 XML 파싱 시작
    func beginParsing()
    {
        if(PharmacyVC.posts.count == 0)
        {
        PharmacyVC.posts = []
        parser = XMLParser(contentsOf: (URL(string:url))!)!
        
        parser.delegate = self
        parser.parse()
        }
        tbData!.reloadData()
    }
    
    // parser가 새로운 element를 발견하면 변수를 생성한다.
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "list")
        {
            elements = NSMutableDictionary()
            elements = [:]
            
            for i in 0..<parameters.count
            {
                datas[parameters[i]] = NSMutableString()
                datas[parameters[i]] = ""
            }
        }
    }
    
    // title과 pubDate를 발견하면 title1과 date에 완성한다.
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        for i in 0..<parameters.count
        {
            if element.isEqual(to: parameters[i])
            {
                datas[parameters[i]]?.append(string)
            }
        }
    }
    
    // element의 끝에서 feed 데이터를 dictionary에 저장
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqual(to: "list")
        {
            for i in 0..<parameters.count
            {
                if !datas[parameters[i]]!.isEqual(nil)
                {
                    elements.setObject(datas[parameters[i]]!, forKey: parameters[i] as NSCopying)
                }
            }
            
            PharmacyVC.posts.add(elements)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return PharmacyVC.posts.count
    }
    
    // 테이블 뷰 셀의 내용은 title과 subtitle을 posts 배열의 원소(사전)에서 title과 date에 해당하는 value로 설정
    func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let adres = (PharmacyVC.posts.object(at: indexPath.row) as AnyObject).value(forKey: "adres") as! NSString as String
        let dataTitle = (PharmacyVC.posts.object(at: indexPath.row) as AnyObject).value(forKey: "dataTitle") as! NSString as String
        
        cell.textLabel?.text = adres
        
        cell.detailTextLabel?.text = dataTitle
        
        return cell // as UITableViewCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToMapView"
        {
            if let mapVC = segue.destination as? PharmacyMapVC
            {
                let la = (PharmacyVC.posts.object(at: 0) as AnyObject).value(forKey: "la") as! NSString as String
                let lo = (PharmacyVC.posts.object(at: 0) as AnyObject).value(forKey: "lo") as! NSString as String
                let lat = (la as NSString).doubleValue
                let lon = (lo as NSString).doubleValue
                
                mapVC.initlocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                mapVC.posts = PharmacyVC.posts
            }
        }
    }
}

//  "adres"/*주소*/,      "dataTitle"/*업소명*/,     "la"/*위도*/,         "lo"/*경도*/,
//  "regData"/*작성일*/,   "remark"/*비고*/,         "telNo"/*연락처*/]
