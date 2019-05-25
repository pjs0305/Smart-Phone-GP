//
//  MinbakMapVC.swift
//  Term Project Jeju
//
//  Created by KPUGAME on 24/05/2019.
//  Copyright © 2019 KPUGAME. All rights reserved.
//

import UIKit
import MapKit

class GoodMapVC: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView : MKMapView!
    
    var posts = NSMutableArray()
    var initLocation : CLLocation!
    
    let regionRadius : CLLocationDistance = 10000
    
    func centerMapOnLocation(location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    var Goods : [Good] = []
    
    func loadInitData()
    {
        for post in posts
        {
            let mapx = (post as AnyObject).value(forKey: "posy") as! NSString as String
            let mapy = (post as AnyObject).value(forKey: "posx") as! NSString as String
            let area = (post as AnyObject).value(forKey: "area") as! NSString as String
            let adres = (post as AnyObject).value(forKey: "adres") as! NSString as String
            let addr = area + " " + adres
            let discipline = (post as AnyObject).value(forKey: "induty") as! NSString as String
            
            let dataTitle = (post as AnyObject).value(forKey: "dataTitle") as! NSString as String
            let lat = (mapx as NSString).doubleValue
            let lon = (mapy as NSString).doubleValue
        
            let minbak = Good(title: dataTitle, addr: addr, discipline: discipline, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
            
            Goods.append(minbak)
        }
        
    }
    
    func mapView(_ mapView : MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control : UIControl)
    {
        let location = view.annotation as! Good
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        centerMapOnLocation(location: initLocation)
        
        mapView.delegate = self
        
        loadInitData()
        mapView.addAnnotations(Goods)
        // Do any additional setup after loading the view.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        // 2. 이 주석(annotation)이 Hospital 객체인지 확인! 그렇지 않으면 nil 지도 뷰에서 기본 주석 뷰를 사용하도록 돌아감.
        guard let annotation = annotation as? Good else { return nil }
        
        // 3. 마커가 나타나게 MKMarkerAnnotationView를 만듦.
        //    이 자습서의 뒷부분에서는 MKAnnotationView 대신 이미지를 표시하는 객체를 만듦.
        
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        // 4. 코드를 새로 생성하기 전에 재사용 가능한 주석 뷰를 사용할 수 있는지 확인.
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        {
            dequeuedView.annotation = annotation
            view = dequeuedView
        }
        else
        {
            // 5. MKMarkerAnnotationView 주석 보기에서 대기열에서 삭제할 수 없는 경우 여기에서 새 객체를 만듦.
            //    Hospital 클래스의 title 및 subtitle 속성을 사용하여 콜 아웃에 표시할 내용을 결정합니다.
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x : -5, y : 5)
            view.rightCalloutAccessoryView = UIButton(type : .detailDisclosure)
            
            // 2. pin icon을 각 discipline의 첫글자로 설정
            view.markerTintColor = annotation.markerTintColor
            view.glyphText = String(annotation.discipline.first!)
        }
        
        return view
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}