//
//  WeatherLocalDb.swift
//  Data
//
//  Created by Deiner Calbang on 3/27/25.
//

import Foundation
import Infrastructure
import Domain

protocol WeatherLocalDb {
    
    func saveWeatherData(country: String, _ weather: Weather) async throws
    func getWeatherData(country: String, city: String) async throws -> Weather
    func getAllWeatherData() async throws -> [Weather]
    func deleteWeatherData(for city: String) async throws
    
}

class WeatherLocalDbImpl: WeatherLocalDb {
    
    private let sqliteHelper: SQLiteHelperProtocol
    
    init(sqliteHelper: SQLiteHelperProtocol) {
        self.sqliteHelper = sqliteHelper
    }
    
    func saveWeatherData(country: String, _ weather: Weather) async throws {
        do {
            if let _ = try sqliteHelper.readWeatherData(country: country, city: weather.cityName ?? "") {
                try sqliteHelper.updateWeatherData(country: country, weather)
            } else {
                try sqliteHelper.createWeatherData(country: country, weather)
            }
        } catch {
            throw error
        }
    }
    
    func getWeatherData(country: String, city: String) async throws -> Weather {
        guard let weather = try sqliteHelper.readWeatherData(country: country, city: city) else {
            throw SQLiteError.dataNotFound
        }
        return weather
    }
    
    func getAllWeatherData() async throws -> [Weather] {
        return try await sqliteHelper.readAllWeatherData()
    }
    
    func deleteWeatherData(for city: String) async throws {
        try sqliteHelper.deleteWeatherData(for: city)
    }
    
}
