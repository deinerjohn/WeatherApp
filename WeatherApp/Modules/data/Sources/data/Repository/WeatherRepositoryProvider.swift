//
//  WeatherRepositoryProvider.swift
//  Data
//
//  Created by Deiner Calbang on 3/22/25.
//

import Foundation
import Domain
import Infrastructure

public class WeatherRepositoryProvider: RepositoryProviderProtocol {
    
    private let localDb = SQLiteHelper()
    private let apiService = WeatherAPIServiceImpl()
    private let networkMonitor: NetworkConnectionMonitor
    
    public init(
        networkMonitor: NetworkConnectionMonitor
    ) {
        self.networkMonitor = networkMonitor
    }

    public func provideWeatherRepository() -> WeatherRepository {
        return WeatherRepositoryImpl(weatherApiService: apiService, localDb: localDb, networkChecker: networkMonitor)
    }
    
}
