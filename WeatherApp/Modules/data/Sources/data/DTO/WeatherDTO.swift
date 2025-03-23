//
//  WeatherDTO.swift
//  Data
//
//  Created by Deiner Calbang on 3/21/25.
//

import Foundation
import Domain

struct WeatherDTO: Codable {
    let weather: [WeatherConditionDTO]
    let main: MainWeatherDTO
    let wind: WindDTO
    let clouds: CloudsDTO
    let id: Int
    let cityName: String
    
    var countryName: String?
    
    enum CodingKeys: String, CodingKey {
        case cityName = "name"
        case weather
        case main
        case wind
        case clouds
        case id
    }
    
}

struct WeatherConditionDTO: Codable {
    let main: String
    let description: String
    let icon: String
}

struct MainWeatherDTO: Codable {
    let temp: Double
    let pressure: Int
    let humidity: Int
    let tempMin: Double
    let tempMax: Double

    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct WindDTO: Codable {
    let speed: Double
    let deg: Int
}

struct CloudsDTO: Codable {
    let all: Int
}

extension WeatherDTO {
    
    func toDomain() -> Weather {
        return Weather(
            weather: weather.map { $0.toDomain() },
            main: main.toDomain(),
            wind: wind.toDomain(),
            clouds: clouds.toDomain(),
            id: id,
            countryName: countryName ?? "",
            cityName: cityName
        )
    }
    
}

extension WeatherConditionDTO {
    func toDomain() -> WeatherCondition {
        return WeatherCondition(
            main: self.main,
            description: self.description,
            icon: self.icon
        )
    }
    
}

extension MainWeatherDTO {
    func toDomain() -> MainWeather {
        return MainWeather(
            temperature: Temperature(value: self.temp),
            pressure: Pressure(value: self.pressure),
            humidity: Humidity(value: self.humidity),
            minTemperature: Temperature(value: self.tempMin),
            maxTemperature: Temperature(value: self.tempMax)
        )
    }
}

extension WindDTO {
    func toDomain() -> Wind {
        return Wind(
            speed: Speed(value: self.speed),
            degree: self.deg
        )
    }
}

extension CloudsDTO {
    func toDomain() -> Clouds {
        return Clouds(
            coverage: self.all
        )
    }
}

