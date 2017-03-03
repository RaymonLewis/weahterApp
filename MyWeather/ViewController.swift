//
//  ViewController.swift
//  MyWeather
//
//  Created by RaymonLewis on 8/15/16.
//  Copyright © 2016 RaymonLewis. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!

    @IBOutlet weak var weatherPredictionTableView: UITableView!
    
    var locationManager : CLLocationManager?
    var cityCoordinates : CLLocationCoordinate2D? {
        didSet{
            if let latitude = self.cityCoordinates?.latitude {
             if let longtitude = self.cityCoordinates?.longitude {
             self.clearData()
             print("You choose city")
             self.getWeatherDataWith(latitude, longtitude: longtitude)
             self.getCityNameWith(latitude, longtitude: longtitude)
             }
             }
        }
    }
    
    var currentWeatherData : CurrentWeatherData? {
        didSet{
            setCurrentWeatherData()
        }
    }
    var dailyWeatherData = [DailyWeatherData]()
    var hourlyWeatherData = [HourlyWeatherData]()

    //MARK: -  Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLocationManager()
        
        weatherPredictionTableView.dataSource = self
        weatherPredictionTableView.delegate = self
        weatherPredictionTableView.backgroundColor = UIColor.clearColor()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.showChooseCityAlertWindow))
        self.cityLabel.addGestureRecognizer(gestureRecognizer)
        
    }
    
    func setCurrentWeatherData() {
        
        if let description = currentWeatherData?.weatherDescription {
            self.descriptionLabel.text = description
        }
        if let temperature = currentWeatherData?.currentTemperature {
            let newTemp = ViewController.fahrenheitToCelcius(temperature)
            let formattedTemp = String(format: "%.f", newTemp)
            self.tempLabel.text = "\(formattedTemp)˚"
        }
        if let humidity = currentWeatherData?.humidity {
            let formattedHumidity = String(format: "%.f", humidity)
            self.humidityLabel.text = "\(formattedHumidity)%"
        }
        if let windSpeed = currentWeatherData?.windSpeed {
            let formattedWindSpeed = String(format: "%.f", windSpeed)
            self.windSpeedLabel.text = "\(formattedWindSpeed) m/s"
        }
        if let icon = currentWeatherData?.currentWeatherIcon {
            print(icon)
            if icon == "clear-day" {
                self.backgroundImage.image = UIImage(named: "clear-day-background")
            }
            if icon == "clear-night" {
                self.backgroundImage.image = UIImage(named: "clear-night-background")
            }
            if icon == "rain" {
                self.backgroundImage.image = UIImage(named: "rain-background")
            }
            if icon == "partly-cloudy-night"  {
                self.backgroundImage.image = UIImage(named: "partly-cloudy-night-background")
            }
            if icon == "partly-cloudy-day" {
                self.backgroundImage.image = UIImage(named: "partly-cloudy-background")
            }
            
        }
        
    }
    
    func showChooseCityAlertWindow() {
        
        let alertController = UIAlertController(title: "Choose City", message: "Choose the city which weather you want to see", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) in
        }
        
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        let alertActionOK = UIAlertAction(title: "OK", style: .Default) { (action) in
            
            if let textField = alertController.textFields?[0] {
                if let city = textField.text {
                    let formattedCity = city.stringByReplacingOccurrencesOfString(" ", withString: "")
                    self.getCityCoordinates(formattedCity)
                }
            }
        }
        
        alertController.addAction(alertActionCancel)
        alertController.addAction(alertActionOK)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
   // Location Manager Configuration
    
     func setLocationManager() {
        
        self.locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        self.locationManager?.delegate = self
        locationManager?.desiredAccuracy =
        kCLLocationAccuracyThreeKilometers
        locationManager?.requestLocation()
        
        if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
            
            self.locationManager?.delegate = self
            locationManager?.desiredAccuracy =
            kCLLocationAccuracyThreeKilometers
            locationManager?.requestLocation()
        }
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager?.requestAlwaysAuthorization()
        }

        
        
        
        
        
        }
    
    // Functrions to convert date
    
    func getDayOfTheWeek(date: NSDate) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfWeekString = dateFormatter.stringFromDate(date)
        return dayOfWeekString
    }
    
    func dateToHours(date: NSDate) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HHa"
        let timeInHours = dateFormatter.stringFromDate(date)
        
        if timeInHours == "20PM" {
            return "20PM"
        }
        if timeInHours == "10PM" {
            return "10PM"
        }
        if timeInHours == "00AM" {
            return "24PM"
        }
        
        let hours = timeInHours.stringByReplacingOccurrencesOfString("0", withString: "")
        return hours
        
    }
    
    static func fahrenheitToCelcius(temperatureInFahrenheits: Float) -> Float {
        
        let celcius = (temperatureInFahrenheits - 32) / 1.8
        return celcius
        //(T(°F) - 32) / 1.8
    }
    
    func clearData() {
        self.currentWeatherData = nil
        self.dailyWeatherData.removeAll()
        self.hourlyWeatherData.removeAll()
    }
    
}

//MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations.last?.coordinate
        
        if let latittude = userLocation?.latitude {
            if let longtitude = userLocation?.longitude {
                getWeatherDataWith(latittude, longtitude: longtitude)
                getCityNameWith(latittude, longtitude: longtitude)
                
                dispatch_async(dispatch_get_main_queue(), { 
                    self.weatherPredictionTableView.reloadData()
                })
            }
        }
        
        manager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
    }
}

//MARK: - WeatherDataDelegate

extension ViewController : WeatherDataDelegate {
    
    func getWeatherDataWith(latitude: CLLocationDegrees , longtitude: CLLocationDegrees ) {
        
        let APIKEY = Constants.APIKey.weatherApiKey
        let url = "https://api.forecast.io/forecast/\(APIKEY)/\(latitude),\(longtitude)"
        
        //1. Send request to the server to get json data
        Alamofire.request(.GET, url).validate().responseJSON { (response) in
            switch response.result {
            case.Success(let jsonData) :
         
                //2. Parse json object for required data
                let json = JSON(jsonData)
                
                let weatherDescription = json["currently"]["summary"].stringValue
                let currentIcon = json["currently"]["icon"].stringValue
                let currentTemperature = json["currently"]["temperature"].floatValue
                let humidity = json["currently"]["humidity"].floatValue * 100
                let windSpeed = json["currently"]["windSpeed"].floatValue
                
                //3. Put retrived data into variable
                self.currentWeatherData = CurrentWeatherData(weatherDescription: weatherDescription, currentTemperature: currentTemperature, windSpeed: windSpeed, humidity: humidity, currentWeatherIcon: currentIcon)
                
                let dailyData = json["daily"]["data"].array
                for id in dailyData! {
                    
                    let time = id["time"].doubleValue
                    let newTime = NSDate(timeIntervalSince1970: time)
                    let dayOfTheWeek = self.getDayOfTheWeek(newTime)
                    
                    let dailyIcon = id["icon"].stringValue
                    let temperatureMin = id["temperatureMin"].floatValue
                    let temperatureMax = id["temperatureMax"].floatValue
                    
                    let dailyData = DailyWeatherData(dayOfTheWeek: dayOfTheWeek, maxTemp: temperatureMax, minTemp: temperatureMin, dailyWeatherIcon: dailyIcon)
                    
                    self.dailyWeatherData.append(dailyData)
                    
                }
                
                let hourlyData = json["hourly"]["data"].array
                for item in hourlyData! {
                    
                    let hourTime = item["time"].doubleValue
                    let convertedTime = NSDate(timeIntervalSince1970: hourTime)
                    let hours = self.dateToHours(convertedTime)
                    
                    let hourlyIcon = item["icon"].stringValue
                    let hourlyTemperature = item["temperature"].floatValue
                    
                    let hourlyData = HourlyWeatherData(timeInHours: hours, hourlyIcon: hourlyIcon, hourlyTemperature: hourlyTemperature)
                    
                    self.hourlyWeatherData.append(hourlyData)
                    
                }
                self.weatherPredictionTableView.reloadData()
                
            case.Failure(let error) :
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func getCityNameWith(latitude: CLLocationDegrees , longtitude: CLLocationDegrees ) {
        
        let APIKEY = Constants.APIKey.googleMapsApiKey
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longtitude)&result_type=administrative_area_level_1&key=\(APIKEY)"
        
        //1. Send request to the server to get json data
        Alamofire.request(.GET, url).validate().responseJSON { (response) in
            switch response.result {
            case.Success(let jsonData) :
                let json = JSON(jsonData)
        
        //2. Parse data and set value
                let cityName = json["results"][0]["formatted_address"].stringValue
                self.cityLabel.text = cityName
                print(cityName)
                
            case.Failure(let error) :
                print("Request failed with error : \(error)")
            }
        }
        
    }
    
    func getCityCoordinates(city: String) {
        
        let APIKEY = Constants.APIKey.googleMapsApiKey
        let url = "https://maps.googleapis.com/maps/api/geocode/json?address=\(city)&key=\(APIKEY)"
        //https://maps.googleapis.com/maps/api/geocode/json?address=Tokyo&key=AIzaSyBKco69CtOeYlN9his3dshfsS3pqHFSbws"
        Alamofire.request(.GET, url).validate().responseJSON { (response) in
            switch response.result {
            case.Success(let data) :
                let json = JSON(data)
                let latitude = json["results"][0]["geometry"]["location"]["lat"].doubleValue
                let longtitude = json["results"][0]["geometry"]["location"]["lng"].doubleValue
                
                self.cityCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                
            case.Failure(let error) :
                print(error)
            }
        }
    }

}

//MARK: - TableViewDataSource

extension ViewController : UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dailyWeatherData.count - 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifiers.detailWeatherCellID) as! DetailTableViewCell
            
            cell.dailyWeatherData = self.dailyWeatherData[indexPath.row]
            
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            
            return cell
        }
        
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifiers.weatherCellID) as! WeatherCell
            
            cell.dailyWeatherData = self.dailyWeatherData[indexPath.row]
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 120
        }
        return 40
    }
}

//MARK: - CollectionViewDataSource

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
            return hourlyWeatherData.count-24
    }
    
    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.Identifiers.collectionViewCellID, forIndexPath: indexPath) as! DetailCollectionViewCell
        
        if indexPath.item == 0 {
            cell.timeLabel.text = "Now"
            return cell
        }
        
        cell.hourlyWeatherData = hourlyWeatherData[indexPath.item]
        
        return cell
    }
}



