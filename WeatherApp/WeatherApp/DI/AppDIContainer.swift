//
//  AppDIContainer.swift
//  WeatherApp
//
//  Created by Deiner Calbang on 3/27/25.
//

import Foundation
import Data
import Infrastructure
import Domain

final class AppDIContainer {
    
    static let shared = AppDIContainer()
    
    private let networkMonitor: NetworkConnectionMonitor
    private let sqliteHelper: SQLiteHelperProtocol
    
    private lazy var weatherRepositoryProvider: WeatherRepositoryProvider = {
        WeatherRepositoryProvider(sqliteHelper: sqliteHelper, networkMonitor: networkMonitor)
    }()
    
    private lazy var weatherRepository: WeatherRepository = {
        weatherRepositoryProvider.provideWeatherRepository()
    }()
    
    private lazy var weatherUseCase: WeatherUseCase = {
        WeatherUseCaseImpl(weatherRepository: weatherRepository)
    }()
    
    private init(
        networkMonitor: NetworkConnectionMonitor = NetworkConnectionMonitor(),
        sqliteHelper: SQLiteHelperProtocol = SQLiteHelper()
    ) {
        self.networkMonitor = networkMonitor
        self.sqliteHelper = sqliteHelper
    }
    
    func makeWeatherMainViewModel() -> WeatherMainViewModel {
        
        return WeatherMainViewModel(
            weatherUseCase: weatherUseCase,
            networkChecker: networkMonitor
        )
    }
    
}
