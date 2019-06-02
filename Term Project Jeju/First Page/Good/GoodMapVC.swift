//
//  MinbakMapVC.swift
//  Term Project Jeju
//
//  Created by KPUGAME on 24/05/2019.
//  Copyright © 2019 KPUGAME. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

extension GoodMapVC: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

extension GoodMapVC: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
    
class GoodMapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var mapView : MKMapView!
    
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
    
    var goods : [String:[Good]] = [:]
    var filteredGoods = [String:[Good]] ()
    
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
        
            let good = Good(title: dataTitle, addr: addr, discipline: discipline, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon), post: post as AnyObject)
            
            if((goods.index(forKey: discipline)) == nil)
            {
                goods[discipline] = []
            }
            
            goods[discipline]?.append(good)
        }
    }
    
    func mapView(_ mapView : MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control : UIControl)
    {
        let location = view.annotation as! Good
        
        switch control {
        case let left where left == view.leftCalloutAccessoryView:
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            location.mapItem().openInMaps(launchOptions: launchOptions)
            break
        case let right where right == view.rightCalloutAccessoryView:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoodDetailTVC") as! GoodDetailTVC
            vc.initialize(post: location.post)
            self.navigationController!.pushViewController(vc, animated: true)
            break
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "업종별 검색"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.scopeButtonTitles = ["모두", "한식", "중식", "일식", "목욕업", "세탁업", "이미용업", "민박업"]
        searchController.searchBar.delegate = self
        
        mapView.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        loadInitData()
        
        for key in goods.keys
        {
            mapView.addAnnotations(goods[key]!)
        }
        
        centerMapOnLocation(location: initlocation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        guard let good = annotation as? Good else { return nil }
        
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        view = MKMarkerAnnotationView(annotation: good, reuseIdentifier: identifier)
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x : -5, y : 5)
        view.rightCalloutAccessoryView = UIButton(type : .detailDisclosure)
        
        let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        leftButton.setImage(UIImage(named: "car"), for: .normal)
        view.leftCalloutAccessoryView = leftButton
        
        // 2. pin icon을 각 discipline의 첫글자로 설정
        view.markerTintColor = good.markerTintColor
        view.glyphText = String(good.discipline.first!)
        
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

    let searchController = UISearchController(searchResultsController: nil)
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredGoods = goods.filter({ (arg0) -> Bool in
            
            let (key, _) = arg0
            
            let doesCategoryMatch = (scope == "모두") || (key == scope)
            
            if searchBarIsEmpty()
            {
                return doesCategoryMatch
            }
            else
            {
                return doesCategoryMatch && key.lowercased().contains(searchText.lowercased())
            }
        })
        
        mapView.removeAnnotations(mapView.annotations)
        
        for key in filteredGoods.keys
        {
            mapView.addAnnotations(filteredGoods[key]!)
        }
    }
}
