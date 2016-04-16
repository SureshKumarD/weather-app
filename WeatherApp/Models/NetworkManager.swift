//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Suresh on 4/16/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit
import SwiftyJSON

class NetworkManager: NSObject {

    // TODO:- All HTTP GET requests...
    // Fetch weather detail from current user location.
    class func getFromServer(urlString : String, params: [String : String], success: (JSON)-> Void, failure :( NSError)->Void) {
        
        //Uses RESTful approach, ie., BaseUrl + Url fragment...
        
        let manager = AFHTTPSessionManager(baseURL: NSURL(string:URL_BASE))
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        //Setting Possible Acceptable Content Types
        manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/plain","application/json", "text/json", "text/javascript", "text/html","text/xml"]) as? Set<String>
        
        // Add api_key like common parameters, along with the existing parameters...
        let composedParams = NetworkManager.addCommonParameter(params)
        
        
         //["lat" : "40.0583", "lon" : "74.4057"]
        manager.GET(urlString, parameters: composedParams , progress: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject?) in
            
                //TODO: - Check for valid response.
            if let responseDict = responseObject as? Dictionary<String, AnyObject> {
                let response = JSON(responseDict)
                
                    //Success call back to the caller...
                    success(response)
            }
           else {
                
                    //Log to acknowledge developer.
                    print("Unrecognized data received")
                }
            }, failure: {
                (task: NSURLSessionDataTask?, error: NSError) in
                
                //Log to acknowledge developer.
                print("error")
                
                //Failure callback to the caller...
                failure( error)
        })
        
    }
    
    class func addCommonParameter(params:[String : String])-> [String : String] {
        var composedDictionary = params
        composedDictionary["appid"] = API_KEY
        return composedDictionary
        
    }

}
