//
//  TotalMapViewController.swift
//  exam
//
//  Created by D7702_09 on 2019. 11. 12..
//  Copyright © 2019년 csd5766. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class TotalMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var dContents: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        mapView.delegate = self
        // Do any additional setup after loading the view.
        print("dContents = \(String(describing: dContents))")
        
        var annos = [MKPointAnnotation]()
        
        if let myItems = dContents {
            for item in myItems {
                let _title = (item as AnyObject).value(forKey: "title")
                let _subtitle = (item as AnyObject).value(forKey: "subtitle")
                let _lat = (item as AnyObject).value(forKey: "lat") as! String
                let _lon = (item as AnyObject).value(forKey: "lon") as! String
                
                let anno = MKPointAnnotation()
                anno.title = _title as! String
                anno.subtitle = _subtitle as! String
                anno.coordinate.latitude = Double(_lat)!
                anno.coordinate.longitude = Double(_lon)!
                self.mapView.addAnnotation(anno)


            }
            
        } else {
            print("dContents의 값은 nil")
        }
        
        
        
        
        
        // 나의 위치 트래킹
        locationManager.startUpdatingLocation()
        
        locationManager.requestAlwaysAuthorization()
        
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        
        
        
        mapView.showsUserLocation = true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "RE"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)as? MKPinAnnotationView
        if annotationView == nil && annotation.title != "My Location"{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            //annotationView?.pinTintColor = UIColor.blue
            annotationView?.animatesDrop = true
            
            
        }
        else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
        
    }
    
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation: CLLocation = locations[0]
        print(userLocation)
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        mapView.setRegion(region, animated: true)
        
    }
    
    
    
    

}
