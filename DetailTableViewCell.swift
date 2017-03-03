//
//  DetailTableViewCell.swift
//  MyWeather
//
//  Created by RaymonLewis on 8/15/16.
//  Copyright © 2016 RaymonLewis. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    
    @IBOutlet weak var detailCollectionView: UICollectionView!
    
    var dailyWeatherData : DailyWeatherData? {
        didSet {
            setWeatherData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setView()
    }
    
    func setWeatherData() {
        if let day = self.dailyWeatherData?.dayOfTheWeek {
            self.dayLabel.text = day
        }
        if let maxTemp = self.dailyWeatherData?.maxTemp {
            let celciusMaxTemp = ViewController.fahrenheitToCelcius(maxTemp)
            let formattedTemp = String(format: "%.f˚", celciusMaxTemp)
            self.highTempLabel.text = formattedTemp
        }
        if let minTemp = self.dailyWeatherData?.minTemp {
            let celciusMinTemp = ViewController.fahrenheitToCelcius(minTemp)
            let formattedTemp = String(format: "%.f˚", celciusMinTemp)
            self.lowTempLabel.text = formattedTemp
        }
    }
    
    func setView() {
        
        self.detailCollectionView.registerNib(UINib(nibName: "DetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.Identifiers.collectionViewCellID)
        
        self.backgroundColor = UIColor.clearColor()
        self.detailCollectionView.backgroundColor = UIColor.clearColor()
        
    }
    
    func setCollectionViewDataSourceDelegate
        <D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>
        (dataSourceDelegate: D, forRow row: Int) {
        
        self.detailCollectionView.delegate = dataSourceDelegate
        self.detailCollectionView.dataSource = dataSourceDelegate
        self.detailCollectionView.tag = row
        self.detailCollectionView.reloadData()
    }

}
