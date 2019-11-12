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
                let address = (item as AnyObject).value(forKey: "address")
                let title = (item as AnyObject).value(forKey: "title")
                let geoCoder = CLGeocoder()
                
                geoCoder.geocodeAddressString(address as! String, completionHandler: { placemarks, error in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let myPlacemarks = placemarks {
                        let myPlacemark = myPlacemarks[0]
                        
                        let anno = MKPointAnnotation()
                        anno.title = title as? String
                        anno.subtitle = address as? String
                        
                        if let myLocation = myPlacemark.location {
                            anno.coordinate = myLocation.coordinate
                            annos.append(anno)
                        }
                        
                    }
                    
                    //self.mapView.showAnnotations(annos, animated: true)
                    self.mapView.addAnnotations(annos)
                } )
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
