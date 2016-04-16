//
//  DataManager.swift
//  WeatherApp
//
//  Created by Suresh on 4/16/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    //SharedInstance...
    static let dataManager = DataManager()
    
    //Activity Indicator...
    var activityIndicator : UIActivityIndicatorView?
    
    //Shared Instance...
    class func sharedDataManager()-> DataManager! {
        return dataManager
    }
    
    override init() {
        
        // Initialize all data members...
        
        // As we don't have any centralized data, this class appears to be
        // less functional...
      
    }

    
    //MARK: - Acitivity Indicator - usage
    func startActivityIndicator() {
        
        if(self.activityIndicator == nil){
            self.activityIndicator  = UIActivityIndicatorView()
            
        }
        self.activityIndicator?.frame = CGRectMake(WIDTH_WINDOW_FRAME/2 - 50, HEIGHT_WINDOW_FRAME/2-50, 100, 100)
        self.activityIndicator?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        let mainWindow = UIApplication.sharedApplication().keyWindow
        mainWindow?.addSubview(self.activityIndicator!)
        
        self.activityIndicator?.startAnimating()
    }
    
    
    func stopActivityIndicator() {
        self.activityIndicator?.stopAnimating()
        self.activityIndicator?.removeFromSuperview()
    }


}
