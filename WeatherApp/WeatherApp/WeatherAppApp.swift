//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Deiner John Calbang on 3/20/25.
//

import SwiftUI
import Domain
import Infrastructure
import Data

@main
struct WeatherAppApp: App {
    private let repositoryProvider: WeatherRepositoryProvider
    private let useCaseProvider: WeatherUseCaseProvider
    private let networkConnectivity: NetworkConnectionMonitor = NetworkConnectionMonitor()
    
    init() {
        self.repositoryProvider = WeatherRepositoryProvider(networkMonitor: self.networkConnectivity)
        self.useCaseProvider = WeatherUseCaseProvider(weatherRepository: repositoryProvider.provideWeatherRepository())
    }
    
    var body: some Scene {
        WindowGroup {
            WeatherMainView(viewModel: WeatherMainViewModel(weatherUseCase: self.useCaseProvider.provideWeatherUseCase(), networkChecker: self.networkConnectivity))
        }
    }
}
