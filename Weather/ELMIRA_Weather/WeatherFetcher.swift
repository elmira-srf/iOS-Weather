//
//  WeatherFetcher.swift
//  ELMIRA_Weather
//
//  Created by Elmira Sarrafi on 2022-05-19.
//

import Foundation
import UIKit

class WeatherFetcher : ObservableObject {
    var apiURL = "https://api.weatherapi.com/v1/current.json?key=15305de31fe648f1b3f133202221905&q=London&aqi=no"
    
    @Published var WeatherFetched = [Weather]()
    
    private static var shared : WeatherFetcher?
    
    static func getInstance() -> WeatherFetcher{
        if shared == nil{
            shared = WeatherFetcher()
        }
        return shared!
    }
    var lat = 51.52
    var lan = -0.11

    public func setLocation(lat:Double,lan:Double){
        self.lat = lat
        self.lan = lan
        self.apiURL = "https://api.weatherapi.com/v1/current.json?key=15305de31fe648f1b3f133202221905&q=\(lat),\(lan)&aqi=no"
        print(apiURL)
    }
    
    func fetchDataFromAPI(){
        guard let api = URL(string: apiURL) else{
            print(#function, "Unable to obtain URL from string")
            return
        }
        URLSession.shared.dataTask(with: api){ (data : Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print(#function, error)
            }else{
                if let httpResponse = response as? HTTPURLResponse{
                    if httpResponse.statusCode == 200{
                        DispatchQueue.global().async {
                            do{
                                if (data != nil){
                                    if let jsonData = data {
                                        print(#function, jsonData)
                                        let decoder = JSONDecoder()
                                        var decodedWeather = try decoder.decode(Weather.self, from: jsonData)
                                        
                                        DispatchQueue.main.async {
                                            self.WeatherFetched.removeAll()
                                            self.WeatherFetched = [decodedWeather]
                                            print(#function, "Data from API \n \(self.WeatherFetched)")
                                        }
                                    }
                                }
                            }catch let error{
                                print(#function, error)
                            }
                        }
                    }else {
                        print(#function, "Unsuccessful response from network call")
                    }
                }
            }
        }.resume()
    }
}
// MY KEY :15305de31fe648f1b3f133202221905
//https://api.weatherapi.com/v1/current.json?key=15305de31fe648f1b3f133202221905&q=London&aqi=no
