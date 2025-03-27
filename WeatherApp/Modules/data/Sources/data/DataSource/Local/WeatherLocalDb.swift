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
        try await sqliteHelper.saveWeatherData(country: country, weather)
    }
    
    func getWeatherData(country: String, city: String) async throws -> Weather {
        return try await sqliteHelper.getWeatherData(country: country, city: city)
    }
    
    func getAllWeatherData() async throws -> [Weather] {
        return try await sqliteHelper.getAllWeatherData()
    }
    
    func deleteWeatherData(for city: String) async throws {
        return try await sqliteHelper.deleteWeatherData(for: city)
    }
    
}
