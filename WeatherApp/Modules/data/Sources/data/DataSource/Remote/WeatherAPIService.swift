//
//  WeatherAPIService.swift
//  Data
//
//  Created by Deiner John Calbang on 3/20/25.
//

import Foundation
import Infrastructure

protocol WeatherAPIService {
    func fetchWeather(city: String, units: String) async throws -> WeatherDTO
}

class WeatherAPIServiceImpl: NetworkRequest, WeatherAPIService {
    
    func fetchWeather(city: String, units: String) async throws -> WeatherDTO {
        return try await request(endpoint: WeatherEndpoints.getWeather(city: city, units: units), responseModel: WeatherDTO.self)
    }
    
}
