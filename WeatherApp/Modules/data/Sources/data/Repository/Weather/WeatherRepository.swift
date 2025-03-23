//
//  WeatherRepository.swift
//  Data
//
//  Created by Deiner John Calbang on 3/21/25.
//

import Foundation
import Domain
import Infrastructure

public class WeatherRepositoryImpl: WeatherRepository {
    
    private let weatherApiService: WeatherAPIService
    private let localDb: SQLiteHelper
    private let networkChecker: NetworkConnectionMonitor
    
    init(weatherApiService: WeatherAPIService, localDb: SQLiteHelper, networkChecker: NetworkConnectionMonitor) {
        self.weatherApiService = weatherApiService
        self.localDb = localDb
        self.networkChecker = networkChecker
    }
    
    public func fetchWeather(country: String, city: String, units: String) async throws -> Weather {
        if networkChecker.isConnected {
            do {
                let weatherDTO = try await weatherApiService.fetchWeather(city: city, units: units)
                
                try await localDb.saveWeatherData(country: country, weatherDTO)
                
                return weatherDTO.toDomain()
            } catch {
                //
            }
        }
        
        return try await getCachedWeather(country: country, city: city)
    }
    
    public func getAllWeatherData() async throws -> [Weather] {
        let cachedData = try await localDb.getAllWeatherData()
        return cachedData.map { $0.toDomain() }
    }
    
    public func removeWeatherData(city: String) async throws {
        try await localDb.deleteWeatherData(for: city)
    }

    private func getCachedWeather(country: String, city: String) async throws -> Weather {
        let cachedData = try await localDb.getWeatherData(country: country, city: city)
        return cachedData.toDomain()
    }
    
}
