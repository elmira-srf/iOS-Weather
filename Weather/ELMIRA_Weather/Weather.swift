//
//  Weather.swift
//  ELMIRA_Weather
//
//  Created by Elmira Sarrafi on 2022-05-19.
//

import Foundation
import UIKit

struct Weather : Codable {
    
    let id: String
    let city: String
    let country: String
    let lat: Double
    let lon: Double
    let condition: String
    let temp: Double
    let feelsLike : Double
    let wind : Double
    let windDir : String
    let humidity : Double
    let UVIndex : Double
    let visibility : Double
    
    enum WeatherKeys : String, CodingKey {
        case location
        case current
        
        enum locationKeys : String, CodingKey {
            case city = "name"
            case country
            case id = "tz_id"
            case lat
            case lon
        }
        enum currentKeys : String, CodingKey {
            case temp = "temp_c"
            case feelsLike = "feelslike_c"
            case wind = "wind_kph"
            case windDir = "wind_dir"
            case humidity
            case UVIndex = "uv"
            case visibility = "vis_km"
            case condition
            enum conditionKeys : String, CodingKey {
                case text
            }
        }
    }
    
    init(from decoder: Decoder) throws {
        let weatherContainer = try decoder.container(keyedBy: WeatherKeys.self)
        
        let locationContainer = try weatherContainer.nestedContainer(keyedBy: WeatherKeys.locationKeys.self, forKey: .location)

        self.id = try locationContainer.decodeIfPresent(String.self, forKey:.id) ?? "N/A"
        self.city = try locationContainer.decodeIfPresent(String.self, forKey:.city) ?? "N/A"
        self.country = try locationContainer.decodeIfPresent(String.self, forKey:.country) ?? "N/A"
        self.lat = try locationContainer.decodeIfPresent(Double.self, forKey:.lat) ?? 0
        self.lon = try locationContainer.decodeIfPresent(Double.self, forKey:.lon) ?? 0
        
        let currentContainer = try weatherContainer.nestedContainer(keyedBy: WeatherKeys.currentKeys.self, forKey: .current)

        self.temp = try currentContainer.decodeIfPresent(Double.self, forKey: .temp) ?? 0
        self.feelsLike = try currentContainer.decodeIfPresent(Double.self, forKey: .feelsLike) ?? 0
        self.wind = try currentContainer.decodeIfPresent(Double.self, forKey: .wind) ?? 0
        self.windDir = try currentContainer.decodeIfPresent(String.self, forKey: .windDir) ?? "N/A"
        self.humidity = try currentContainer.decodeIfPresent(Double.self, forKey: .humidity) ?? 0
        self.UVIndex = try currentContainer.decodeIfPresent(Double.self, forKey: .UVIndex) ?? 0
        self.visibility = try currentContainer.decodeIfPresent(Double.self, forKey: .visibility) ?? 0
        
        let conditionContainer = try currentContainer.nestedContainer(keyedBy: WeatherKeys.currentKeys.conditionKeys.self, forKey: .condition)

        self.condition = try conditionContainer.decodeIfPresent(String.self, forKey: .text) ?? "N/A"
    }
    func encode(to encoder: Encoder) throws {
        //nothing to encode
    }
}
