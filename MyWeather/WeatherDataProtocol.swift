
// Several data model classes which represents the data which will be used in the app.. 

import UIKit
import CoreLocation

protocol WeatherDataDelegate {
    
    func getWeatherDataWith(latitude: CLLocationDegrees , longtitude: CLLocationDegrees )
    func getCityNameWith(latitude: CLLocationDegrees , longtitude: CLLocationDegrees )
    func getCityCoordinates(city: String)
}


