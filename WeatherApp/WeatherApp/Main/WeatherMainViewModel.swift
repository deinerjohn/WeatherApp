//
//  WeatherMainViewModel.swift
//  WeatherApp
//
//  Created by Deiner Calbang on 3/21/25.
//

import Foundation
import SwiftUI
import Combine
import Domain
import Infrastructure

class WeatherMainViewModel: ObservableObject {
    
    private let weatherUseCase: WeatherUseCase
    private let networkChecker: NetworkConnectionMonitor
    
    @Published var listOfCountries: [Country] = []
    @Published var weatherListData: [Weather] = []
    @Published var selectedCountryWeatherData: Weather?
    @Published var showDetailWeather: Bool = false
    @Published var selectedCountry: Country? {
        didSet {
            self.getCountryWeatherInfo()
        }
    }
    @Published var searchValue: String = ""
    @Published var isOffline: Bool = false
    @Published var isLoading: Bool = false
    
    @AppStorage("temperatureUnit") var temperatureUnit: String = "metric"
    
    init(weatherUseCase: WeatherUseCase, networkChecker: NetworkConnectionMonitor) {
        self.weatherUseCase = weatherUseCase
        self.networkChecker = networkChecker
        self.listOfCountries = self.loadCountries()
        
        networkChecker.onStatusChange = { [weak self] isOnline in
            guard let self else { return }
            DispatchQueue.main.async {
                self.isOffline = !isOnline
            }
        }
        
    }
    
    private func initialCheckIfNoConnection() {
        self.isOffline = !self.networkChecker.isConnected
    }
    
    private func willShowLoading(_ bool: Bool) async {
        await MainActor.run {
            self.isLoading = bool
        }
    }
    
    func loadWeatherData() {
        Task {
            
            await self.willShowLoading(true)
            
            do {
                let weatherData = try await weatherUseCase.getAllWeatherData()
                
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.weatherListData = weatherData
                }
            } catch {
                
            }
            
            await self.willShowLoading(false)
        }
    }
    
    private func getCountryWeatherInfo() {
        guard let selectedCountry else { return }
        Task {
            await self.willShowLoading(true)
            
            do {
                let weatherData = try await weatherUseCase.execute(country: selectedCountry.country, city: selectedCountry.city ?? "", units: self.temperatureUnit)
                self.loadWeatherData()
                
                await MainActor.run {
                    self.selectedCountryWeatherData = weatherData
                    self.showDetailWeather = true
                }
                
            } catch {
                
            }
            
            await self.willShowLoading(false)
        }
    }
    
    func deleteWeatherData(at offSets: IndexSet) {
        Task {
            await self.willShowLoading(true)
            do {
                
                let cityToDelete = offSets.map { self.weatherListData[$0].cityName ?? "" }.first ?? ""
                
                try await self.weatherUseCase.deleteWeatherData(city: cityToDelete)
                
                await MainActor.run {
                    self.loadWeatherData()
                }
                
            } catch {
                
            }
            await self.willShowLoading(true)
        }
    }
    
    func updateAndReloadAllCachedWeather(units: String? = nil) {
        guard !self.weatherListData.isEmpty else { return }
        
        Task {
            await self.willShowLoading(true)
            
            await withTaskGroup(of: Void.self) { group in
                for data in weatherListData {
                    group.addTask {
                        do {
                            _ = try await self.weatherUseCase.execute(country: data.countryName, city: data.cityName ?? "", units: units ?? self.temperatureUnit )
                        } catch {
                            
                        }
                    }
                }
            }
            
            await MainActor.run {
                self.loadWeatherData()
            }
            await self.willShowLoading(false)
        }
    }

}

//MARK: - Loading coutries.json, for search content
extension WeatherMainViewModel {
    
    private func loadCountries() -> [Country] {
        if let url = Bundle.main.url(forResource: "countries", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decodedData = try JSONDecoder().decode([Country].self, from: data)
                
                return decodedData
                
            } catch {
                return []
            }
        }
        return []
    }
    
    var filteredCountries: [Country] {
        if searchValue.isEmpty {
            return []
        } else {
            return listOfCountries.filter { $0.country.lowercased().contains(searchValue.lowercased()) || ($0.city?.lowercased().contains(searchValue.lowercased()) ?? false) }
        }
    }
    
}
