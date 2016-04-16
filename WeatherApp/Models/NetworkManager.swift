//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Suresh on 4/16/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {

    // Uses for get request...
    // Fetch weather detail from current user location.
    class func getFromServer(urlString : String, params: [String : String], success: ([String : AnyObject]?)-> Void, failure :( NSError)->Void) {
        
        let manager = AFHTTPSessionManager(baseURL: NSURL(string:URL_BASE))
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/plain","application/json", "text/json", "text/javascript", "text/html","text/xml"]) as? Set<String>
       
        //["lat" : "13.0375846949078", "lon" : "77.6319722087643"]
        manager.GET(urlString, parameters:params , progress: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject?) in
        
                if let responseDict : [String : AnyObject] = responseObject as? [String:AnyObject] {
                    success(responseDict)
                }else {
                    print("Unrecognized data received")
                }
            }, failure: {
                (task: NSURLSessionDataTask?, error: NSError) in
                print("error")
                failure( error)
        })
        
    }

    
//    class func addCommonParameters(params : [String : String]) -> [String : String] {
//        let commonParams = params + ["app_id" : API_KEY];
//        return (commonParams)
//        
//    }
}
