//
//  DailyWeatherData.swift
//  MyWeather
//
//  Created by RaymonLewis on 8/18/16.
//  Copyright © 2016 RaymonLewis. All rights reserved.
//

import Foundation

class DailyWeatherData {
    
    var dayOfTheWeek: String?
    var maxTemp : Float?
    var minTemp : Float?
    var dailyWeatherIcon : String?
    
    init(dayOfTheWeek: String, maxTemp : Float, minTemp : Float, dailyWeatherIcon : String) {
        
        self.dayOfTheWeek = dayOfTheWeek
        self.maxTemp = maxTemp
        self.minTemp = minTemp
        self.dailyWeatherIcon = dailyWeatherIcon
    }
    
}
