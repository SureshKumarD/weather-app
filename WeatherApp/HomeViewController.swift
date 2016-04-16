//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Suresh on 4/16/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

class HomeViewController: BaseViewController, CLLocationManagerDelegate {

    
    //Story outlets for different labels...
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherMainLabel: UILabel!
    @IBOutlet weak var weatherDesriptionLabel: UILabel!
    @IBOutlet weak var sunRiseCaptionLabel: UILabel!
    @IBOutlet weak var sunRiseInfoLabel: UILabel!
    @IBOutlet weak var sunSetCaptionLabel: UILabel!
    @IBOutlet weak var sunSetInfoLabel: UILabel!
    @IBOutlet weak var temparatureAverageLabel: UILabel!
    @IBOutlet weak var temparatureMinLabel: UILabel!
    @IBOutlet weak var temparatureMaxLabel: UILabel!
    @IBOutlet weak var humidityCaptionLabel: UILabel!
    @IBOutlet weak var humidityInfoLabel: UILabel!
    @IBOutlet weak var windCaptionLabel: UILabel!
    @IBOutlet weak var windSpeedCaptionLabel: UILabel!
    @IBOutlet weak var windSpeedInfoLabel: UILabel!
    @IBOutlet weak var windDegreeCaptionLabel: UILabel!
    @IBOutlet weak var windDegreeInfoLabel: UILabel!
    
    
    //Location Manager Instance...
    //Used to identifiy the user's current location...
    var locationManager : CLLocationManager = CLLocationManager()
    var dateFormat : NSDateFormatter!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initializations/allocations required objects
        self.initializations()
        
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
    func initializations() {
        self.dateFormat = NSDateFormatter()
        self.dateFormat.dateFormat = "hh :mm a"
    }

    //MARK:- Locate user
    func locationUsersCurrentLocation() {
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    
    //MARK:- Location Manager Delegate
    
    //---------------------------------------------------------------------------------------------
    // Two get the user location I've overridden two methods from the LocationManagerDelegate
    // protocol, These two methods are enough to get the latitude and longitude of the user
    // location. Firstly 'didChangeAuthorizationStatus' method get called to get the authorization 
    // status and request for authorization functionalities. From there, if the use allowed to
    // share the user location with our app, then from the 'locationManager.startUpdatingLocation()' 
    // method gets the user locations. So, the 'didUpdateLocations' method has list of user locations
    // we will be needing the top/recent location from the list. And from the location we can get the
    // latitude and logitude of the user location. These two data are passed with the api to get the 
    // user location. Once we get the response we'll populate the data on the Application UI.
    //---------------------------------------------------------------------------------------------
    
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
            
            // Unwrap the latitude & longitude data
            // to pass these as parameter in the openweatherapp api...
            latitude  = "\(location!.coordinate.latitude)"
            longitude  = "\(location!.coordinate.longitude)"
    
        }
        catch  {
            
            // Developer log: to initimate that something wrong happened while unwrapping
            // location object...
            print("Error while unwrapping")

        }
        
        params = ["lat" : latitude! ,"lon" : longitude!] as NSDictionary!
        
//        print("params \(params)")
        DataManager.sharedDataManager().startActivityIndicator()
        let urlString = "/"+URL_DATA+"/"+API_VERSION+"/"+URL_FRAGMENT_WEATHER
        NetworkManager.getFromServer(urlString, params: params as! [String : String], success: { (response : JSON) -> Void in
            
            DataManager.sharedDataManager().stopActivityIndicator()
            //populate received data on UI...
            self.populateDataOnUI(response)
            
            }) { (error :NSError) -> Void in
                DataManager.sharedDataManager().stopActivityIndicator()
                self.showAlertView("Error", message: error.localizedDescription)
                self.locationManager.stopUpdatingLocation()
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        self.showAlertView("Something went wrong!", message: error.localizedDescription)
        locationManager.stopUpdatingLocation()
       
    }
    
    //MARK:- Alert local
    func showAlertView(title: String!, message : String!) {
        let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    
    
    //MARK:- Populate Data On UI
    func populateDataOnUI(jsonData: JSON!) {
    
        // If the error dictionary received...
        // Acknowledge the user, and stop proceeding...
        var tempString : String!
        var date : NSDate!
        if(jsonData["name"] == nil){
            self.showAlertView("Something went wrong!", message: "Try again later...")
            return
        }
        
        // If the data is valid...
        self.cityNameLabel.text = jsonData["name"].stringValue
        self.weatherMainLabel.text = jsonData["weather"][0]["main"].stringValue
        self.weatherDesriptionLabel.text = jsonData["weather"][0]["description"].stringValue
        
        //Sun rise timing...
        self.sunRiseCaptionLabel.text = "Sunrise:"
        tempString = jsonData["sys"]["sunrise"].stringValue
        date = NSDate(timeIntervalSince1970: Double(tempString)!)
        self.sunRiseInfoLabel.text = self.dateFormat.stringFromDate(date)
        
        //Sun set timing...
        self.sunSetCaptionLabel.text = "Sunset:"
        tempString = jsonData["sys"]["sunset"].stringValue
        date = NSDate(timeIntervalSince1970: Double(tempString)!)
        self.sunSetInfoLabel.text = self.dateFormat.stringFromDate(date)
        
        //Temparature kelvin to celcius conversion...
        tempString = String(Double(jsonData["main"]["temp"].stringValue)! - 273.15)
        self.temparatureAverageLabel.text = "Temparature " + tempString + " C"
        
        tempString = String(Double(jsonData["main"]["temp_min"].stringValue)! - 273.15)
        self.temparatureMinLabel.text = "Min "+tempString + " C"
        
        tempString = String(Double(jsonData["main"]["temp_max"].stringValue)! - 273.15)
        self.temparatureMaxLabel.text = "Max "+tempString + " C"
        
        //Humidity...
        self.humidityCaptionLabel.text = "Humidity:"
        self.humidityInfoLabel.text = jsonData["main"]["humidity"].stringValue
        
        //Wind...
        self.windCaptionLabel.text = "Wind"
        self.windDegreeCaptionLabel.text = "Degree:"
        self.windDegreeInfoLabel.text = jsonData["wind"]["deg"].stringValue
        
        self.windSpeedCaptionLabel.text = "Speed:"
        // Speed m/s to km/hr conversion...
        tempString = String(Double(jsonData["wind"]["speed"].stringValue)! * 3.6)
        self.windSpeedInfoLabel.text = tempString + " km/hr"

        
        
    }
    
}

