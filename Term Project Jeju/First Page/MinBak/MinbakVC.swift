//
//  MinbacVC.swift
//  Term Project Jeju
//
//  Created by KPUGAME on 18/05/2019.
//  Copyright © 2019 KPUGAME. All rights reserved.
//

import UIKit
import MapKit

class MinbakVC: UIViewController, XMLParserDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tbData : UITableView!
    
    var parser = XMLParser()
    
    // feed 데이터를 저장하는 mutable array
    var posts = NSMutableArray()
    
    // title과 date 같은 feed 데이터를 저장하는 mutable dictionary
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var url : String! = "http://openapi.jejusi.go.kr/rest/minbakinfoservice/getMinbakInfoList?serviceKey=7Z3e6MM%2BZVra4DYqS7dDT%2Bsfh%2Fw2JlIBVc4uE9Xc%2FEKVgineKHp9fvznQMmblhdNhsBaCa2S31NGHVGY2j9gLg%3D%3D&pageNo=1&numOfRows=10"
    var parameters : [String] = ["addr", "mapx", "mapy", "name", "room"]
    var datas : [String: NSMutableString] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beginParsing()
    }
    
    // parse 오브젝트 초기화하고 XMLParserDelegate로 설정하고 XML 파싱 시작
    func beginParsing()
    {
        posts = []
        parser = XMLParser(contentsOf: (URL(string:url))!)!
        
        parser.delegate = self
        parser.parse()
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
            
            posts.add(elements)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return posts.count
    }
    
    // 테이블 뷰 셀의 내용은 title과 subtitle을 posts 배열의 원소(사전)에서 title과 date에 해당하는 value로 설정
    func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let text1 = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "name") as! NSString as String
        
        let text2 = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "addr") as! NSString as String
        
        cell.textLabel?.text = text1
        
        cell.detailTextLabel?.text = text2
        
        return cell // as UITableViewCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToMapView"
        {
            if let mapVC = segue.destination as? MinbakMapVC
            {
                let mapx = (posts.object(at: 0) as AnyObject).value(forKey: "mapx") as! NSString as String
                let mapy = (posts.object(at: 0) as AnyObject).value(forKey: "mapy") as! NSString as String
                let lat = (mapx as NSString).doubleValue
                let lon = (mapy as NSString).doubleValue
                
                mapVC.initLocation = CLLocation(latitude: lat, longitude: lon)
                mapVC.posts = posts
            }
        }
    }
}
