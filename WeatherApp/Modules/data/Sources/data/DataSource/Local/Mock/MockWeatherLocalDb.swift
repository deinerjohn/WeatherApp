//
//  MockWeatherLocalDb.swift
//  Data
//
//  Created by Deiner Calbang on 3/27/25.
//

import Foundation
import Domain

class MockWeatherLocalDb: WeatherLocalDb {
    
    var storedWeatherData: [String: Weather] = [:]
    
    func saveWeatherData(country: String, _ weather: Weather) async throws {
        storedWeatherData["\(country)-\(weather.cityName ?? "")"] = weather
    }
    
    func getWeatherData(country: String, city: String) async throws -> Weather {
        if let weather = storedWeatherData[city] {
            return weather
        }
        throw NSError(domain: "MockWeatherLocalDb", code: 1, userInfo: [NSLocalizedDescriptionKey: "No data found"])
    }
    
    func getAllWeatherData() async throws -> [Weather] {
        return Array(storedWeatherData.values)
    }
    
    func deleteWeatherData(for city: String) async throws {
        storedWeatherData = storedWeatherData.filter { !$0.key.contains(city) }
    }
    
}
