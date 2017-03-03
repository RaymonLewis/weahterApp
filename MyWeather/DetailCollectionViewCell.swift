//
//  DetailCollectionViewCell.swift
//  MyWeather
//
//  Created by RaymonLewis on 8/16/16.
//  Copyright © 2016 RaymonLewis. All rights reserved.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    var hourlyWeatherData : HourlyWeatherData? {
        didSet {
            if let time = hourlyWeatherData?.timeInHours {
                self.timeLabel.text = time
            }
            if let temp = hourlyWeatherData?.hourlyTemperature {
                let celcius = ViewController.fahrenheitToCelcius(temp)
                let formattedTemp = String(format: "%.f˚", celcius)
                self.tempLabel.text = formattedTemp
            }
            if let icon = hourlyWeatherData?.hourlyIcon {
                self.weatherIcon.image = UIImage(named: icon)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    
}
