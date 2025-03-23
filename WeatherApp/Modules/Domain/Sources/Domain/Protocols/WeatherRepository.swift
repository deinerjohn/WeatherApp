//
//  WeatherRepository.swift
//  Domain
//
//  Created by Deiner Calbang on 3/22/25.
//

import Foundation

public protocol RepositoryProviderProtocol {
    func provideWeatherRepository() -> WeatherRepository
}

public protocol WeatherRepository {
    func fetchWeather(country: String, city: String, units: String) async throws -> Weather
    func getAllWeatherData() async throws -> [Weather]
    func removeWeatherData(city: String) async throws
}
