//
//  SQLiteHelper.swift
//  Data
//
//  Created by Deiner Calbang on 3/21/25.
//

import Foundation
import SQLite

enum SQLiteError: Error {
    case databaseNotInitialized
    case dataNotFound
}

protocol SQLiteHelperProtocol {
    func saveWeatherData(country: String, _ weather: WeatherDTO) async throws
    func getWeatherData(country: String, city: String) async throws -> WeatherDTO
    func getAllWeatherData() async throws -> [WeatherDTO]
    func deleteWeatherData(for city: String) async throws
}

class SQLiteHelper: SQLiteHelperProtocol {
    private var db: Connection?
    
    private let weatherTable = Table("weather")
    private let id: SQLite.Expression<Int> = Expression("id")
    private let countryName: SQLite.Expression<String> = Expression("countryName")
    private let cityName: SQLite.Expression<String> = Expression("cityName")
    private let temperature: SQLite.Expression<Double> = Expression("temperature")
    private let description: SQLite.Expression<String> = Expression("description")
    private let main: SQLite.Expression<String> = Expression("main")  // For WeatherCondition.main
    private let icon: SQLite.Expression<String> = Expression("icon")  // For WeatherCondition.icon
    private let tempMin: SQLite.Expression<Double> = Expression("temp_min")  // For MainWeather.tempMin
    private let tempMax: SQLite.Expression<Double> = Expression("temp_max")  // For MainWeather.tempMax
    private let pressure: SQLite.Expression<Int> = Expression("pressure")  // For MainWeather.pressure
    private let humidity: SQLite.Expression<Int> = Expression("humidity")  // For MainWeather.humidity
    private let windSpeed: SQLite.Expression<Double> = Expression("wind_speed")  // For Wind.speed
    private let windDeg: SQLite.Expression<Int> = Expression("wind_deg")  // For Wind.deg
    private let cloudiness: SQLite.Expression<Int> = Expression("cloudiness")  // For Clouds.all
    private let timestamp: SQLite.Expression<Double> = Expression("timestamp")  // For timestamp
    private let fileName = "weather_app.sqlite3"

    init() {
        self.initDB()
    }
    
    private func initDB() {
        do {
            let dbPath = dbPath()
            print("This is your db file path: \(dbPath)")
            db = try Connection(dbPath)
            try createTables()
        } catch {
            
        }
    }
    
    private func dbPath() -> String {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0].appendingPathComponent(fileName).path
    }

    private func createTables() throws {
        try db?.run(weatherTable.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(countryName)
            t.column(cityName, unique: true)
            t.column(temperature)
            t.column(description)
            t.column(main)
            t.column(icon)
            t.column(tempMin)
            t.column(tempMax)
            t.column(pressure)
            t.column(humidity)
            t.column(windSpeed)
            t.column(windDeg)
            t.column(cloudiness)
            t.column(timestamp, defaultValue: Date().timeIntervalSince1970)
        })
    }

    func saveWeatherData(country: String, _ weather: WeatherDTO) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let existingQuery = weatherTable.filter(cityName == weather.cityName)
                
                if let _ = try db?.pluck(existingQuery) {
                    // country exists, update the entry
                    let update = existingQuery.update(
                        temperature <- weather.main.temp,
                        description <- weather.weather.first?.description ?? "",
                        main <- weather.weather.first?.main ?? "",
                        icon <- weather.weather.first?.icon ?? "",
                        tempMin <- weather.main.tempMin,
                        tempMax <- weather.main.tempMax,
                        pressure <- weather.main.pressure,
                        humidity <- weather.main.humidity,
                        windSpeed <- weather.wind.speed,
                        windDeg <- weather.wind.deg,
                        cloudiness <- weather.clouds.all,
                        timestamp <- Date().timeIntervalSince1970
                    )
                    try db?.run(update)
                } else {
                    // country does not exist, insert new entry
                    let insert = weatherTable.insert(
                        countryName <- country,
                        cityName <- weather.cityName,
                        temperature <- weather.main.temp,
                        description <- weather.weather.first?.description ?? "",
                        main <- weather.weather.first?.main ?? "",
                        icon <- weather.weather.first?.icon ?? "",
                        tempMin <- weather.main.tempMin,
                        tempMax <- weather.main.tempMax,
                        pressure <- weather.main.pressure,
                        humidity <- weather.main.humidity,
                        windSpeed <- weather.wind.speed,
                        windDeg <- weather.wind.deg,
                        cloudiness <- weather.clouds.all,
                        timestamp <- Date().timeIntervalSince1970
                    )
                    try db?.run(insert)
                }
                continuation.resume()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    func getWeatherData(country: String, city: String) async throws -> WeatherDTO {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                guard let db = db else {
                    throw SQLiteError.databaseNotInitialized
                }
                
                let query = weatherTable.filter(cityName == city)
                
                if let record = try db.pluck(query) {
                    let weather = WeatherDTO(
                        weather: [WeatherConditionDTO(
                            main: record[main],
                            description: record[description],
                            icon: record[icon]
                        )],
                        main: MainWeatherDTO(
                            temp: record[temperature],
                            pressure: record[pressure],
                            humidity: record[humidity],
                            tempMin: record[tempMin],
                            tempMax: record[tempMax]
                        ),
                        wind: WindDTO(speed: record[windSpeed], deg: record[windDeg]),
                        clouds: CloudsDTO(all: record[cloudiness]),
                        id: record[id],
                        cityName: record[cityName],
                        countryName: record[countryName]
                    )
                    continuation.resume(returning: weather)
                } else {
                    continuation.resume(throwing: SQLiteError.dataNotFound)
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    func getAllWeatherData() async throws -> [WeatherDTO] {
        
        return try await withCheckedThrowingContinuation { continuation in
            do {
                guard let db = db else {
                    throw SQLiteError.databaseNotInitialized
                }
                
                let weatherRecords = try db.prepare(weatherTable)
                var weatherList: [WeatherDTO] = []

                for record in weatherRecords {
                    let weather = WeatherDTO(
                        weather: [WeatherConditionDTO(
                            main: record[main],
                            description: record[description],
                            icon: record[icon]
                        )],
                        main: MainWeatherDTO(
                            temp: record[temperature],
                            pressure: record[pressure],
                            humidity: record[humidity],
                            tempMin: record[tempMin],
                            tempMax: record[tempMax]
                        ),
                        wind: WindDTO(speed: record[windSpeed], deg: record[windDeg]),
                        clouds: CloudsDTO(all: record[cloudiness]),
                        id: record[id],
                        cityName: record[cityName],
                        countryName: record[countryName]
                    )
                    weatherList.append(weather)
                }

                continuation.resume(returning: weatherList)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    func deleteWeatherData(for city: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let query = weatherTable.filter(self.cityName == city)
                try db?.run(query.delete())
                continuation.resume()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
}
