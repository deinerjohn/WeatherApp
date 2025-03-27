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
    
    private let sqliteHelper: SQLiteHelperProtocol
    private let networkMonitor: NetworkConnectionMonitor
    
    public init(
        sqliteHelper: SQLiteHelperProtocol,
        networkMonitor: NetworkConnectionMonitor
    ) {
        self.sqliteHelper = sqliteHelper
        self.networkMonitor = networkMonitor
    }

    public func provideWeatherRepository() -> WeatherRepository {
        let localDb = WeatherLocalDbImpl(sqliteHelper: self.sqliteHelper)
        let apiService = WeatherAPIServiceImpl()
        return WeatherRepositoryImpl(weatherApiService: apiService, localDb: localDb, networkChecker: networkMonitor)
    }
    
}
