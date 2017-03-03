//
//  WeatherCell.swift
//  MyWeather
//
//  Created by RaymonLewis on 8/15/16.
//  Copyright © 2016 RaymonLewis. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    var dailyWeatherData : DailyWeatherData? {
        didSet {
            setDailyWeatherData()
        }
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()
    }
    
    func setDailyWeatherData() {
        
        if let day = self.dailyWeatherData?.dayOfTheWeek {
            self.dayLabel.text = day
        }
        if let maxTemp = self.dailyWeatherData?.maxTemp {
            let celciusMaxTemp = ViewController.fahrenheitToCelcius(maxTemp)
            let formattedTemp = String(format: "%.f˚", celciusMaxTemp)
            self.maxTempLabel.text = formattedTemp
        }
        if let minTemp = self.dailyWeatherData?.minTemp {
            let celciusMinTemp = ViewController.fahrenheitToCelcius(minTemp)
            let formattedTemp = String(format: "%.f˚", celciusMinTemp)
            self.minTempLabel.text = formattedTemp
        }
        if let icon = self.dailyWeatherData?.dailyWeatherIcon {
            self.weatherIcon.image = UIImage(named: "\(icon)")
        }
    }
    
}
