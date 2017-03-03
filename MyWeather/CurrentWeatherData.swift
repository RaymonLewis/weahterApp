//
//  CurrentWeatherData.swift
//  MyWeather
//
//  Created by RaymonLewis on 8/18/16.
//  Copyright © 2016 RaymonLewis. All rights reserved.
//

import Foundation

class CurrentWeatherData {
    
    var weatherDescription : String?
    var currentTemperature : Float?
    var windSpeed : Float?
    var humidity : Float?
    var currentWeatherIcon : String?
    
    init(weatherDescription: String, currentTemperature : Float, windSpeed: Float, humidity : Float, currentWeatherIcon : String ) {
        self.weatherDescription = weatherDescription
        self.currentTemperature = currentTemperature
        self.windSpeed = windSpeed
        self.humidity = humidity
        self.currentWeatherIcon = currentWeatherIcon
    }
    
}
