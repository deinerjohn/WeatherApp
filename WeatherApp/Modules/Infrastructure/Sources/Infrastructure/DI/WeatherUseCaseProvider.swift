//
//  WeatherUseCaseProvider.swift
//  Infrastructure
//
//  Created by Deiner Calbang on 3/22/25.
//

import Foundation
import Domain

public class WeatherUseCaseProvider {
    private let weatherRepository: WeatherRepository

    public init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }

    public func provideWeatherUseCase() -> WeatherUseCase {
        return WeatherUseCaseImpl(weatherRepository: weatherRepository)
    }
}
