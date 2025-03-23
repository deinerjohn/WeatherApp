//
//  Weather.swift
//  Domain
//
//  Created by Deiner John Calbang on 3/21/25.
//

public struct Weather: Identifiable, @unchecked Sendable {
    
    public let weather: [WeatherCondition]
    public let main: MainWeather
    public let wind: Wind
    public let clouds: Clouds
    public let id: Int
    public let countryName: String
    public let cityName: String?
    
    public init(weather: [WeatherCondition], main: MainWeather, wind: Wind, clouds: Clouds, id: Int, countryName: String, cityName: String?) {
        self.weather = weather
        self.main = main
        self.wind = wind
        self.clouds = clouds
        self.id = id
        self.countryName = countryName
        self.cityName = cityName
    }
}

public struct WeatherCondition {
    public let main: String
    public let description: String
    public let icon: String
    
    public init(main: String, description: String, icon: String) {
        self.main = main
        self.description = description
        self.icon = icon
    }
}

public struct MainWeather {
    public let temperature: Temperature
    public let pressure: Pressure
    public let humidity: Humidity
    public let minTemperature: Temperature
    public let maxTemperature: Temperature
    
    public init(temperature: Temperature, pressure: Pressure, humidity: Humidity, minTemperature: Temperature, maxTemperature: Temperature) {
        self.temperature = temperature
        self.pressure = pressure
        self.humidity = humidity
        self.minTemperature = minTemperature
        self.maxTemperature = maxTemperature
    }
}

public struct Temperature {
    public let value: Double
    
    public init(value: Double) {
        self.value = value
    }
}

public struct Pressure {
    public let value: Int
    
    public init(value: Int) {
        self.value = value
    }
}

public struct Humidity {
    public let value: Int
    
    public init(value: Int) {
        self.value = value
    }
}

public struct Wind {
    public let speed: Speed
    public let degree: Int
    
    public init(speed: Speed, degree: Int) {
        self.speed = speed
        self.degree = degree
    }
}

public struct Speed {
    public let value: Double
    
    public init(value: Double) {
        self.value = value
    }
}

public struct Clouds {
    public let coverage: Int
    
    public init(coverage: Int) {
        self.coverage = coverage
    }
}

