//
//  MinbakMapVC.swift
//  Term Project Jeju
//
//  Created by KPUGAME on 24/05/2019.
//  Copyright © 2019 KPUGAME. All rights reserved.
//

import UIKit
import MapKit

class PharmacyMapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var mapView : MKMapView!
    static var posts = NSMutableArray()
    
    let locationManager = CLLocationManager()
    var posts = NSMutableArray()
    var initlocation = CLLocationCoordinate2D()
    
    let regionRadius : CLLocationDistance = 5000
    
    @IBAction func userlocation(_ sender: Any) {
        centerMapOnLocation(location : mapView.userLocation.coordinate)
    }
    
    func centerMapOnLocation(location : CLLocationCoordinate2D)
    {
        mapView.showsUserLocation = true
        
        let coordinateRegion = MKCoordinateRegion.init(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    var items : [Pharmacy] = []
    
    static func GetPost(name : String) -> Pharmacy?
    {
        for post in PharmacyMapVC.posts
        {
            if (post as AnyObject).value(forKey: "dataTitle") as! NSString as String != name
            {
                continue
            }
            
            let la = (post as AnyObject).value(forKey: "la") as! NSString as String
            let lo = (post as AnyObject).value(forKey: "lo") as! NSString as String
            let addr = (post as AnyObject).value(forKey: "adres") as! NSString as String
            let dataTitle = (post as AnyObject).value(forKey: "dataTitle") as! NSString as String
            let lat = (la as NSString).doubleValue
            let lon = (lo as NSString).doubleValue
            
            let pharmacy = Pharmacy(title: dataTitle, addr: addr, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon), post : post as AnyObject)
            
            return pharmacy
        }
        
        return nil
    }
    
    func loadInitData()
    {
        for post in PharmacyMapVC.posts
        {
            let la = (post as AnyObject).value(forKey: "la") as! NSString as String
            let lo = (post as AnyObject).value(forKey: "lo") as! NSString as String
            let addr = (post as AnyObject).value(forKey: "adres") as! NSString as String
            let dataTitle = (post as AnyObject).value(forKey: "dataTitle") as! NSString as String
            let lat = (la as NSString).doubleValue
            let lon = (lo as NSString).doubleValue
        
            let pharmacy = Pharmacy(title: dataTitle, addr: addr, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon), post : post as AnyObject)
            
            items.append(pharmacy)
        }
        
    }
    
    @IBAction func MoveNearFromMapLocation(_ sender: Any) {
        let mapCenter = mapView.centerCoordinate
        
        centerMapOnLocation(location: self.FindNearLocation(center: mapCenter))
    }
    
    @IBAction func MoveNearFromMyLocation(_ sender: Any) {
        let mapCenter = mapView.userLocation.coordinate
        
        centerMapOnLocation(location: self.FindNearLocation(center: mapCenter))
    }
    
    func FindNearLocation(center : CLLocationCoordinate2D) -> CLLocationCoordinate2D
    {
        var location : CLLocationCoordinate2D
        var nearestlat : Double
        var nearestlon : Double
        
        location = (items.first!.coordinate)
        nearestlat = fabs(center.latitude - (items.first!.coordinate.latitude))
        nearestlon = fabs(center.longitude - (items.first!.coordinate.longitude))
        
        for item in items
        {
            let distlat = fabs(center.latitude - item.coordinate.latitude)
            let distlon = fabs(center.longitude - item.coordinate.longitude)
            
            if ( distlat + distlon < nearestlat + nearestlon)
            {
                location = item.coordinate
                nearestlat = distlat
                nearestlon = distlon
            }
        }
        
        return location
    }
    
    func mapView(_ mapView : MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control : UIControl)
    {
        let location = view.annotation as! Pharmacy
        
        switch control {
        case let left where left == view.leftCalloutAccessoryView:
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            location.mapItem().openInMaps(launchOptions: launchOptions)
            break
        case let right where right == view.rightCalloutAccessoryView:
            PageViewController.history.append(["심야 약국" : location.title!])
            PageViewController.myTableView.reloadData()
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PharmacyDetailTVC") as! PharmacyDetailTVC
            vc.initialize(post: location.post)
            self.navigationController!.pushViewController(vc, animated: true)
            break
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        loadInitData()
        
        let la = (PharmacyMapVC.posts.object(at: 0) as AnyObject).value(forKey: "la") as! NSString as String
        let lo = (PharmacyMapVC.posts.object(at: 0) as AnyObject).value(forKey: "lo") as! NSString as String
        let lat = (la as NSString).doubleValue
        let lon = (lo as NSString).doubleValue
        centerMapOnLocation(location: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        
        mapView.addAnnotations(items)
        // Do any additional setup after loading the view.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        // 2. 이 주석(annotation)이 Hospital 객체인지 확인! 그렇지 않으면 nil 지도 뷰에서 기본 주석 뷰를 사용하도록 돌아감.
        guard let annotation = annotation as? Pharmacy else { return nil }
        
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
            
            let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            leftButton.setImage(UIImage(named: "car"), for: .normal)
            view.leftCalloutAccessoryView = leftButton
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
