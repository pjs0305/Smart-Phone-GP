//
//  Minbak.swift
//  Term Project Jeju
//
//  Created by KPUGAME on 24/05/2019.
//  Copyright © 2019 KPUGAME. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class Good : NSObject, MKAnnotation
{
    let title : String? // 무조건 이 이름!
    let addr : String
    let coordinate : CLLocationCoordinate2D
    let discipline : String
    let post : AnyObject!
    
    // MKAnnotation 프로토콜을 구현하기 위해서 title, subtitle, coordinate 등 필요
    // 사용자가 핀을 선택할 때 title/subtitle을 표시
    init(title: String, addr : String, discipline : String, coordinate : CLLocationCoordinate2D, post : AnyObject)
    {
        self.title = title
        self.addr = addr
        self.coordinate = coordinate
        self.discipline = discipline
        self.post = post
        
        super.init()
    }
    
    // subtitle은 Name을 반환하는 computed property
    var subtitle : String?
    {
        return addr
    }
    
    // 클래스에 추가하는 helper 메소드
    // MKPlacemark로부터 MKMapItem을 생성
    // info button을 누르면 MKMapItem을 오픈하게 됨
    func mapItem() -> MKMapItem
    {
        
        let addressDict = [CNPostalAddressStreetKey: self.subtitle!]
        let placemark = MKPlacemark(coordinate: self.coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.title
        
        return mapItem
    }
    
    var markerTintColor : UIColor
    {
        switch discipline
        {
        case "한식" :
            return .red
        case "목욕업":
            return .cyan
        case "세탁업":
            return .blue
        case "이미용업":
            return .purple
        case "중식":
            return .green
        case "일식":
            return .orange
        case "민박업":
            return .yellow
        default:
            return .magenta
        }
    }
}
