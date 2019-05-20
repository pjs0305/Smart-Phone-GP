//
//  MinbacVC.swift
//  Term Project Jeju
//
//  Created by KPUGAME on 18/05/2019.
//  Copyright © 2019 KPUGAME. All rights reserved.
//

import UIKit

class MinbakVC: UIViewController, XMLParserDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tbData : UITableView!
    
    var parser = XMLParser()
    
    // feed 데이터를 저장하는 mutable array
    var posts = NSMutableArray()
    
    // title과 date 같은 feed 데이터를 저장하는 mutable dictionary
    var elements = NSMutableDictionary()
    var element = NSString()
    
    // 저장 문자열 변수
    var addr = NSMutableString()
    var name = NSMutableString()
    var room = NSMutableString()
    var mapx = NSMutableString()
    var mapy = NSMutableString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beginParsing()
    }
    
    // parse 오브젝트 초기화하고 XMLParserDelegate로 설정하고 XML 파싱 시작
    func beginParsing()
    {
        posts = []
        parser = XMLParser(contentsOf: (URL(string:"http://openapi.jejusi.go.kr/rest/minbakinfoservice/getMinbakInfoList?serviceKey=7Z3e6MM%2BZVra4DYqS7dDT%2Bsfh%2Fw2JlIBVc4uE9Xc%2FEKVgineKHp9fvznQMmblhdNhsBaCa2S31NGHVGY2j9gLg%3D%3D&pageNo=1&numOfRows=10"))!)!
        
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
            addr = NSMutableString()
            addr = ""
            name = NSMutableString()
            name = ""
            room = NSMutableString()
            room = ""
            mapx = NSMutableString()
            mapx = ""
            mapy = NSMutableString()
            mapy = ""
        }
    }
    
    // title과 pubDate를 발견하면 title1과 date에 완성한다.
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if element.isEqual(to: "addr")
        {
            addr.append(string)
        }
        else if element.isEqual(to: "mapx")
        {
            mapx.append(string)
        }
        else if element.isEqual(to: "mapy")
        {
            mapy.append(string)
        }
        else if element.isEqual(to: "name")
        {
            name.append(string)
        }
        else if element.isEqual(to: "room")
        {
            room.append(string)
        }
    }
    
    // element의 끝에서 feed 데이터를 dictionary에 저장
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqual(to: "list")
        {
            if !addr.isEqual(nil)
            {
                elements.setObject(addr, forKey: "addr" as NSCopying)
            }
            
            if !name.isEqual(nil)
            {
                elements.setObject(name, forKey: "name" as NSCopying)
            }
            
            if !mapx.isEqual(nil)
            {
                elements.setObject(mapx, forKey: "mapx" as NSCopying)
            }
            
            if !mapy.isEqual(nil)
            {
                elements.setObject(mapy, forKey: "mapy" as NSCopying)
            }
            
            if !room.isEqual(nil)
            {
                elements.setObject(room, forKey: "room" as NSCopying)
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
        
        print(text1)
        print(text2)
        
        cell.textLabel?.text = text1
        
        cell.detailTextLabel?.text = text2
        
        return cell // as UITableViewCell
    }
}
