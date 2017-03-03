//
//  HourlyWeatherData.swift
//  MyWeather
//
//  Created by RaymonLewis on 8/18/16.
//  Copyright © 2016 RaymonLewis. All rights reserved.
//

import Foundation

class HourlyWeatherData {
    
    var timeInHours : String?
    var hourlyIcon : String?
    var hourlyTemperature : Float?
    
    init(timeInHours : String, hourlyIcon : String, hourlyTemperature : Float) {
        
        self.timeInHours = timeInHours
        self.hourlyIcon = hourlyIcon
        self.hourlyTemperature = hourlyTemperature
    }
    
}
