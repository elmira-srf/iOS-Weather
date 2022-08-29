//
//  ViewController.swift
//  ELMIRA_Weather
//
//  Created by Elmira Sarrafi on 2022-05-19.
//

import UIKit
import CoreLocation
import Combine

class ViewController: UIViewController, CLLocationManagerDelegate {

    // MARK: Outlets
    
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblCondition: UILabel!
    
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblFeelsLike: UILabel!
    @IBOutlet weak var lblWind: UILabel!
    @IBOutlet weak var lblWindDir: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblUV: UILabel!
    @IBOutlet weak var lblVisibility: UILabel!
    
    private let weatherFetcher = WeatherFetcher.getInstance()
    private var weatherFetched = [Weather]()

    private var cancellables : Set<AnyCancellable> = []
    
    var locationManager:CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        weatherFetcher.fetchDataFromAPI()
        self.receiveChanges()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Received a location!")
        if let lastKnownLocation = locations.first{

            let lat = lastKnownLocation.coordinate.latitude
            let lan = lastKnownLocation.coordinate.longitude
            print("Current location: \(lat), \(lan)")
            self.weatherFetcher.setLocation(lat: lat, lan: lan)
            self.weatherFetcher.fetchDataFromAPI()
            self.receiveChanges()
            
            self.lblCity.text = weatherFetched[0].city
            self.lblCountry.text = weatherFetched[0].country
            self.lblCondition.text = weatherFetched[0].condition
            self.lblTemp.text = "\(weatherFetched[0].temp)"
            self.lblFeelsLike.text = "\(weatherFetched[0].feelsLike)"
            self.lblWind.text = "\(weatherFetched[0].wind)"
            self.lblWindDir.text = weatherFetched[0].windDir
            self.lblHumidity.text = "\(weatherFetched[0].humidity)"
            self.lblUV.text = "\(weatherFetched[0].UVIndex)"
            self.lblVisibility.text = "\(weatherFetched[0].visibility)"
        
        }
    }
    private func receiveChanges(){
        self.weatherFetcher.$WeatherFetched
            .receive(on: RunLoop.main)
            .sink{(updatedWeatherObjects) in
                self.weatherFetched.removeAll()
                self.weatherFetched.append(contentsOf: updatedWeatherObjects)
            }
            .store(in: &cancellables)
    }
}

