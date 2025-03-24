//
//  MockSQLiteHelper.swift
//  Data
//
//  Created by Deiner Calbang on 3/24/25.
//

class MockSQLiteHelper: SQLiteHelperProtocol {
    
    var storedWeatherData: [String: WeatherDTO] = [:]
    
    func saveWeatherData(country: String, _ weather: WeatherDTO) async throws {
        storedWeatherData[weather.cityName] = weather
    }

    func getWeatherData(country: String, city: String) async throws -> WeatherDTO {
        guard let weather = storedWeatherData[city] else {
            throw SQLiteError.dataNotFound
        }
        return weather
    }

    func getAllWeatherData() async throws -> [WeatherDTO] {
        return Array(storedWeatherData.values)
    }

    func deleteWeatherData(for city: String) async throws {
        storedWeatherData.removeValue(forKey: city)
    }
    
}
