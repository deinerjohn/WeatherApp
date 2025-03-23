//
//  WeatherEndpoints.swift
//  Data
//
//  Created by Deiner John Calbang on 3/20/25.
//

import Foundation
import Infrastructure

enum WeatherEndpoints: Endpoint {
    
    case getWeather(city: String, units: String)
    
    var baseUrl: String {
        return "https://api.openweathermap.org/data/2.5"
    }
    
    var path: String {
        return "/weather"
    }
    
    var queries: [String : String] {
        switch self {
        case .getWeather(let city, let units):
            return [
                "q": city,
                "appid": apiKey,
                "units": units
            ]
        }
    }
    
    var method: Infrastructure.RequestMethod {
        switch self {
        case .getWeather:
            return .get
        }
    }
    
}
