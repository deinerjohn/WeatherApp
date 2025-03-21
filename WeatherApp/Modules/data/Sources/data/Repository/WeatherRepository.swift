//
//  WeatherRepository.swift
//  Data
//
//  Created by Deiner John Calbang on 3/21/25.
//

struct WeatherDTO: Decodable {
    
}

/*
protocol WeatherRepository {
    func getWeather(forCity city: String) async throws -> Weather
}

class WeatherRepositoryImpl: WeatherRepository {
    private let networkService: NetworkService
    private let db: Database
    
    init(networkService: NetworkService, db: Database) {
        self.networkService = networkService
        self.db = db
    }
    
    func getWeather(forCity city: String) async throws -> Weather {
        let endpoint = Endpoint.currentWeather(city: city)
        
        // Try to fetch data from network
        do {
            let data = try await networkService.fetchData(from: endpoint)
            let response = try JSONDecoder().decode(WeatherDTO.self, from: data)
            // Save to local database
            try db.saveWeatherData(response)
            return Weather(id: UUID().uuidString, cityName: city, temperature: response.currentTemperature, description: response.description)
        } catch {
            // If network fails, fallback to local database
            if let cachedWeather = try db.getWeather(forCity: city) {
                return cachedWeather
            } else {
                throw WeatherRepositoryError.noDataAvailable
            }
        }
    }
}
*/
