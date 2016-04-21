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
    @IBOutlet weak var sunRiseInfoLabel: UILabel!
        @IBOutlet weak var sunSetInfoLabel: UILabel!
    @IBOutlet weak var temparatureAverageLabel: UILabel!
   
    @IBOutlet weak var temparatureMinMaxLabel: UILabel!
   
    @IBOutlet weak var humidityInfoLabel: UILabel!
    @IBOutlet weak var windCaptionLabel: UILabel!
    @IBOutlet weak var windSpeedInfoLabel: UILabel!
    @IBOutlet weak var windDegreeInfoLabel: UILabel!
    
    
    //Location Manager Instance...
    //Used to identifiy the user's current location...
    var locationManager : CLLocationManager = CLLocationManager()
    var dateFormat : NSDateFormatter!
    
    //No information display...
    var noInfoContainerView : UIView!
    var noInfoLabel : UILabel!
    
    var reloadLocationButton : UIButton!
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
        self.instantiateNoInfoView()
    }
    
    
    func instantiateNoInfoView() {
        
        //No Info - Information Label...
        if(noInfoLabel == nil) {
            self.noInfoLabel = UILabel(frame: CGRect(x: 10, y: 10, width: WIDTH_WINDOW_FRAME - 50, height: 100))
        }
        self.noInfoLabel.font = UIFont(name: "HelveticaNeue", size: 15.0)
        self.noInfoLabel.textColor = UIColor.grayColor()
        self.noInfoLabel.minimumScaleFactor = 0.5
        self.noInfoLabel.numberOfLines = 0
        self.noInfoLabel.text = " Unable to get your location, Please make sure you've enabled location services in device.!!!"
        
        //Reload location Button...
        if(self.reloadLocationButton == nil) {
            self.reloadLocationButton = UIButton(type: .Custom)
        }
        self.reloadLocationButton.frame = CGRect(x: WIDTH_WINDOW_FRAME/2 - 65, y: 110, width: 100, height: 30)
        self.reloadLocationButton.setTitle("Reload", forState: UIControlState.Normal)
        self.reloadLocationButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.reloadLocationButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        self.reloadLocationButton.addTarget(self, action: Selector("reloadLocationUpdate:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.reloadLocationButton.backgroundColor = UIColor.grayColor()
        
        //No info container view...
        if(noInfoContainerView == nil) {
            self.noInfoContainerView = UIView(frame: CGRect(x: 15, y: HEIGHT_WINDOW_FRAME/2-75, width: WIDTH_WINDOW_FRAME - 30, height: 150))
        }
        self.noInfoContainerView.layer.masksToBounds = true
        self.noInfoContainerView.layer.cornerRadius = 5.0
        self.noInfoContainerView.layer.borderColor = UIColor.blackColor().CGColor
        self.noInfoContainerView.layer.borderWidth = 1.0
        self.noInfoContainerView.backgroundColor = UIColor.whiteColor()
        self.noInfoContainerView.addSubview(self.noInfoLabel)
        self.noInfoContainerView.addSubview(self.reloadLocationButton)
        
    }

    //MARK:- Locate user
    func locationUsersCurrentLocation() {
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    
    //MARK:- Reload Location Action
    func reloadLocationUpdate(sender : AnyObject) {
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
                var errorTitle : String!
                var errorMessage : String!
                if(error.code == -1011) {
                    errorTitle = "Authorization Required!"
                    errorMessage = "Configure OpenWeatherMap.org's Api Key..."
                }else {
                    errorTitle = "Error!"
                    errorMessage = error.localizedDescription
                }
                self.showAlertView(errorTitle, message: errorMessage)
                self.locationManager.stopUpdatingLocation()
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        self.showAlertView("Something went wrong!", message: error.localizedDescription, cancelButtonTitle:"Cancel", otherButtons: ["Open Settings"])
        locationManager.stopUpdatingLocation()
       
    }
    
    //MARK:- Alert local
    func showAlertView(title: String!, message : String!) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert);
       
        //no event handler (just close dialog box)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: {(action:UIAlertAction) in
            
            //Add noInfoLabel on self.view
            self.instantiateNoInfoView()
            self.view.addSubview(self.noInfoContainerView)
            
        }))
        presentViewController(alert, animated: true, completion: nil)

    }
    
    func showAlertView(title: String!, message : String!, cancelButtonTitle: String!, otherButtons:[String!]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert);
        
        //no event handler (just close dialog box)
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: UIAlertActionStyle.Cancel, handler: {(action:UIAlertAction) in
            
                //Add noInfoLabel on self.view
               self.instantiateNoInfoView()
               self.view.addSubview(self.noInfoContainerView)
            
            }));
        //event handler with closure
        alert.addAction(UIAlertAction(title: otherButtons[0] as String!, style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction) in

           //TODO:- Check device version is greater than or equal to 9.0
            if(PlatformVersion.iOS_9_plus){
                
                //If the device os version is >= 9.0 then goes to Settings->Privacy section...
                UIApplication.sharedApplication().openURL(NSURL(string: "prefs:root=Privacy")!)
                
            }else {
                
                //Else go to the WeatherApp's location sharing settings...
                UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!)
            }
            
            
        }))
        presentViewController(alert, animated: true, completion: nil)
    }

    
    
    
    //MARK:- Populate Data On UI
    func populateDataOnUI(jsonData: JSON!) {
    
        //Remove noinfo container from self.view if it's already available...
        self.noInfoContainerView.removeFromSuperview()
        
        // If the error dictionary received...
        // Acknowledge the user, and stop proceeding...
        var tempString : String!
        var tempString2 : String!
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
        tempString = jsonData["sys"]["sunrise"].stringValue
        date = NSDate(timeIntervalSince1970: Double(tempString)!)
        self.sunRiseInfoLabel.text = "Sunrise:  " + self.dateFormat.stringFromDate(date)
        
        //Sun set timing...
        tempString = jsonData["sys"]["sunset"].stringValue
        date = NSDate(timeIntervalSince1970: Double(tempString)!)
        self.sunSetInfoLabel.text = "Sunset:  " + self.dateFormat.stringFromDate(date)
        
        //Temparature kelvin to celcius conversion...
        tempString = String(Double(jsonData["main"]["temp"].stringValue)! - 273.15)
        self.temparatureAverageLabel.text = "Temparature " + tempString + " C"
        
        tempString = String(Double(jsonData["main"]["temp_min"].stringValue)! - 273.15)
        tempString2 = "Min "+tempString + " C"
        
        tempString = String(Double(jsonData["main"]["temp_max"].stringValue)! - 273.15)
        self.temparatureMinMaxLabel.text = tempString2 + "    " + "Max "+tempString + " C"
        
        //Humidity...
        self.humidityInfoLabel.text = "Humidity:  " + jsonData["main"]["humidity"].stringValue
        
        //Wind...
        self.windCaptionLabel.text = "Wind"
        self.windDegreeInfoLabel.text = "Degree:  " + jsonData["wind"]["deg"].stringValue
    
        // Speed m/s to km/hr conversion...
        tempString = String(Double(jsonData["wind"]["speed"].stringValue)! * 3.6)
        self.windSpeedInfoLabel.text = "Speed:  " + tempString + " km/hr"

        
        
    }
    
}

