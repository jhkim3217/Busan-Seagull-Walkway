//
//  DetailMapViewController.swift
//  exam
//
//  Created by D7702_09 on 2019. 11. 12..
//  Copyright © 2019년 csd5766. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var dTitle: String?
    var dAddress: String?
    var userLocation: CLLocation?
    var dLat: String?
    var dLon: String?
    var dPoint: MKPointAnnotation?

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        
        
        // Do any additional setup after loading the view.
        print("dTitle = \(String(describing: dTitle))")
        print("dAddress = \(String(describing: dAddress))")
        print("dLat = \(String(describing: dLat))")
        
        
        // navigation title 설정
        self.title = dTitle
        
        // geoCoding
//        let geoCoder = CLGeocoder()
//        geoCoder.geocodeAddressString(dAddress!, completionHandler: { plackmarks, error in
//
//            if error != nil {
//                print(error!)
//            }
//
//            if plackmarks != nil {
//                let myPlacemark  = plackmarks?[0]
//
//                if (myPlacemark?.location) != nil {
//
//                    //self.mapView.setRegion(region, animated: true)
//
//                    // Pin 꼽기, title, suttitle
//                    let anno = MKPointAnnotation()
//                    anno.title = self.dTitle
//                    anno.subtitle = self.dAddress
//                    anno.coordinate = (myPlacemark?.location?.coordinate)!
//                    self.dPoint = anno
//                    self.mapView.addAnnotation(anno)
//                    //self.mapView.selectAnnotation(anno, animated: true)
//                }
//            }
//
//        } )
        
        let anno = MKPointAnnotation()
        anno.title = self.dTitle
        anno.subtitle = self.dAddress
        anno.coordinate.latitude = Double(dLat!)!
        anno.coordinate.longitude = Double(dLon!)!
        self.dPoint = anno
        self.mapView.addAnnotation(anno)
        
        
        let center = CLLocationCoordinate2D(latitude: (anno.coordinate.latitude), longitude: anno.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        mapView.setRegion(region, animated: true)
        
        
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
        
        userLocation = locations[0]
        print(userLocation)
        
        let center = CLLocationCoordinate2D(latitude: (userLocation?.coordinate.latitude)!, longitude: userLocation!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        //mapView.setRegion(region, animated: true)
        
    }
    
    @IBAction func navigate(_ sender: Any) {
        let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: (userLocation?.coordinate.latitude)!, longitude: (userLocation?.coordinate.longitude)!)))
        source.name = "내 위치"
        
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: (dPoint?.coordinate.latitude)!, longitude: (dPoint?.coordinate.longitude)!)))
        destination.name = dTitle
        
        MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])

    }
    
    
    
    


}
