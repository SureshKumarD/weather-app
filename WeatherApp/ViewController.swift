//
//  ViewController.swift
//  WeatherApp
//
//  Created by Suresh on 4/16/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {

    
    var locationManager : CLLocationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.locationUsersCurrentLocation()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- METHODS
    

    //MARK:- Locate user
    func locationUsersCurrentLocation() {
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    
    //MARK:- Location Manager Delegate
    
    // Change in authroization status
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // 2
        switch status {
        case .NotDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .AuthorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .AuthorizedAlways:
            locationManager.startUpdatingLocation()
            break
        case .Restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .Denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break

            
        }
    }
    
    
    //Did update the locations
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //Get the recent/top location objects from array of locations objects.
        let location = locations.last 
        
        //Start updating the user location...
        self.locationManager.stopUpdatingLocation()
        var params : NSDictionary!
        var latitude : String!
        var longitude : String!
        
        do {
            latitude  = "\(location!.coordinate.latitude)"
            longitude  = "\(location!.coordinate.longitude)"
    
        }
        catch  {
            print("Error while unwrapping")

        }
        
        params = ["lat" : latitude! ,"lon" : longitude!, "appid" : API_KEY] as NSDictionary!
        
        print("params \(params)")
        let urlString = "/"+URL_DATA+"/"+API_VERSION+"/"+URL_FRAGMENT_WEATHER
        NetworkManager.getFromServer(urlString, params: params as! [String : String], success: { (response : [String : AnyObject]?) -> Void in
            print("success %@", response)
            }) { (error :NSError) -> Void in
                self.showAlertView("Error", message: error.localizedDescription)
        }
        
    
        
        
        
//        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
//        location?.coordinate.latitude
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        
//        self.mapView.setRegion(region, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let alertView = UIAlertView(title: "Something went wrong!", message: error.localizedDescription, delegate: self, cancelButtonTitle: "OK")
        alertView.show()

    }
    
    //MARK:- Alert local
    func showAlertView(title: String!, message : String!) {
        let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
    
}

