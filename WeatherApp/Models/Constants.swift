//
//  Constants.swift
//  WeatherApp
//
//  Created by Suresh on 4/16/16.
//  Copyright © 2016 Suresh. All rights reserved.
//

import Foundation

//Configuration Constants...
let URL_BASE  = "http://api.openweathermap.org"
let API_VERSION = "2.5"
let URL_FRAGMENT_WEATHER = "weather"
let URL_DATA = "data"

//Replace your API_KEY with the empty string below...
let API_KEY = ""

//Other Constants...
let NUMBER_ZERO = 0
let NUMBER_ONE = 1
let NUMBER_TWO = 2
let NUMBER_THREE = 3
let NUMBER_FOUR = 4
let NUMBER_FIVE = 5

//Frame windo...
let WIDTH_WINDOW_FRAME =  UIScreen.mainScreen().bounds.size.width
let HEIGHT_WINDOW_FRAME =  UIScreen.mainScreen().bounds.size.height

//Platform version
//let kCURRENT_DEVICE_PLATFORM_VERSION =  UIDevice.currentDevice().systemVersion as String!
let kCURRENT_DEVICE_PLATFORM_VERSION  =  NSProcessInfo.processInfo().operatingSystemVersion


struct PlatformVersion {
    static let SYS_VERSION_FLOAT = (UIDevice.currentDevice().systemVersion as NSString).floatValue
    static let iOS_9_plus = (PlatformVersion.SYS_VERSION_FLOAT >= 9.0)
}