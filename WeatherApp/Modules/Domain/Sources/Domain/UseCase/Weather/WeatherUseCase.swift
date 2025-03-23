//
//  WeatherUseCase.swift
//  Domain
//
//  Created by Deiner John Calbang on 3/21/25.
//

import Foundation

public protocol WeatherUseCase {
    func execute(country: String, city: String, units: String) async throws -> Weather
    func getAllWeatherData() async throws -> [Weather]
    func deleteWeatherData(city: String) async throws
}

public class WeatherUseCaseImpl: WeatherUseCase {
    
    private let weatherRepository: WeatherRepository
    
    public init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }
    
    public func execute(country: String, city: String, units: String) async throws -> Weather {
        return try await weatherRepository.fetchWeather(country: country, city: city, units: units)
    }
    
    public func getAllWeatherData() async throws -> [Weather] {
        return try await weatherRepository.getAllWeatherData()
    }
    
    public func deleteWeatherData(city: String) async throws {
        return try await weatherRepository.removeWeatherData(city: city)
    }
    
}
