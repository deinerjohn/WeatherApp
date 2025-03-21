//
//  WeatherUseCase.swift
//  Domain
//
//  Created by Deiner John Calbang on 3/21/25.
//

/*
protocol WeatherUseCase {
    func execute(forCity city: String) async throws -> Weather
}

class WeatherUseCaseImpl: WeatherUseCase {
    private let weatherRepository: WeatherRepository
    
    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }
    
    func execute(forCity city: String) async throws -> Weather {
        do {
            // Attempt to get fresh weather data from the repository
            return try await weatherRepository.getWeather(forCity: city)
        } catch WeatherRepositoryError.noDataAvailable {
            // Handle case where no data is available locally or via API
            throw WeatherUseCaseError.noDataAvailable
        } catch {
            // Handle any other errors (e.g., API errors, network failures)
            throw WeatherUseCaseError.failedToFetchData
        }
    }
}
*/
