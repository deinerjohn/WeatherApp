//
//  MockWeatherAPIService.swift
//  Data
//
//  Created by Deiner Calbang on 3/24/25.
//

import Foundation

class MockWeatherAPIService: WeatherAPIService {
    var mockResponse: WeatherDTO?
    var mockError: Error?
    
    func fetchWeather(city: String, units: String) async throws -> WeatherDTO {
        if let error = mockError { throw error }
        if let response = mockResponse { return response }
        throw URLError(.badServerResponse) 
    }
}
