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
    
    private let sqliteHelper = SQLiteHelper()
    private let repositoryProvider: WeatherRepositoryProvider
    private let useCaseProvider: WeatherUseCaseProvider
    private let networkConnectivity: NetworkConnectionMonitor = NetworkConnectionMonitor()
    
    @State private var isShowSplashScreen: Bool = true
    
    init() {
        self.repositoryProvider = WeatherRepositoryProvider(sqliteHelper: sqliteHelper, networkMonitor: self.networkConnectivity)
        self.useCaseProvider = WeatherUseCaseProvider(weatherRepository: repositoryProvider.provideWeatherRepository())
    }
    
    var body: some Scene {
        WindowGroup {
            if isShowSplashScreen {
                SplashScreenView(isShowSplash: $isShowSplashScreen)
            } else {
                WeatherMainView(viewModel: WeatherMainViewModel(weatherUseCase: self.useCaseProvider.provideWeatherUseCase(), networkChecker: self.networkConnectivity))
            }
        }
    }
}
