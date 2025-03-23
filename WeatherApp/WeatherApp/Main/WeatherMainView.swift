//
//  WeatherMainView.swift
//  WeatherApp
//
//  Created by Deiner John Calbang on 3/20/25.
//

import SwiftUI
import Infrastructure
import Data
import Domain

struct WeatherMainView: View {
    
    @StateObject var viewModel: WeatherMainViewModel
    @FocusState private var isSearchFocused: Bool
    
    @Environment(\.dismissSearch) private var dismissSearch
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("temperatureUnit") private var temperatureUnit: String = "metric"
    
    var body: some View {
        NavigationStack {
            VStack {
                
                if !viewModel.filteredCountries.isEmpty { //It will monitor filteredCountries, once true it will show list.
                    GeometryReader { geometry in
                        List(viewModel.filteredCountries) { country in
                            
                            Button(action: {
                                viewModel.selectedCountry = country
                                viewModel.searchValue = ""
                                isSearchFocused = false
                                dismissSearch()
                                
                            }) {
                                HStack {
                                    
                                    if let city = country.city {
                                        Text("\(city), \(country.country)")
                                    } else {
                                        Text("\(country.country)")
                                    }
                                    
                                    Spacer()
                                }
                            }
                        }
                        .listStyle(.plain)
                        .frame(height: geometry.size.height)
                    }
                }
                
                ZStack {
                    
                    VStack(spacing: 0) {
                        
                        if viewModel.isOffline { //Detecting offline, or no connection will show this.
                            HStack {
                                Image(systemName: "wifi.slash")
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                    .transition(.scale(scale: 0.5).combined(with: .opacity))
                                Text("No internet connection")
                                    .font(.caption)
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .animation(.spring(), value: true)
                        }
                        
                        if viewModel.searchValue.isEmpty { //Hide temporarily if start typing..
                            
                            List {
                                ForEach(viewModel.weatherListData) { weather in
                                    ZStack {
                                        WeatherRowView(weatherData: weather)
                                        NavigationLink(destination: WeatherDetailedView(weatherData: weather)) {
                                            EmptyView()
                                        }
                                        .opacity(0)
                                    }
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                }
                                .onDelete(perform: viewModel.deleteWeatherData)
                                
                            }
                            .listStyle(.plain)
                            .background(.clear)
                            
                        }
                        
                    }
                    
                    if viewModel.isLoading {
                        WeatherLoadingView()
                    }
                    
                }
                .navigationTitle("Weather Demo App")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button(action: {
                                temperatureUnit = "metric"
                                self.viewModel.updateAndReloadAllCachedWeather(units: "metric")
                            }) {
                                Label("Metric", systemImage: temperatureUnit == "metric" ? "checkmark" : "")
                            }
                            
                            Button(action: {
                                temperatureUnit = "imperial"
                                self.viewModel.updateAndReloadAllCachedWeather(units: "imperial")
                            }) {
                                Label("Imperial", systemImage: temperatureUnit == "imperial" ? "checkmark" : "")
                            }
                            
                        } label: {
                            Image(systemName: "gearshape")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                    }
                }
                .searchable(text: $viewModel.searchValue, prompt: "Search for a country")
                .focused($isSearchFocused)
                .onChange(of: viewModel.searchValue) { _ in
                    viewModel.objectWillChange.send()
                }
                .refreshable {
                    self.viewModel.updateAndReloadAllCachedWeather()
                }
                
            }
            .navigationDestination(isPresented: $viewModel.showDetailWeather) {
                WeatherDetailedView(weatherData: viewModel.selectedCountryWeatherData, selectedCountry: viewModel.selectedCountry?.country)
            }
        }
        .onAppear {
            self.viewModel.loadWeatherData()
        }
    }
    
}

#Preview {
    let repository = WeatherRepositoryProvider(networkMonitor: NetworkConnectionMonitor())
    let useCase = WeatherUseCaseProvider(weatherRepository: repository.provideWeatherRepository())
    WeatherMainView(viewModel: WeatherMainViewModel(weatherUseCase: useCase.provideWeatherUseCase(), networkChecker: NetworkConnectionMonitor()))
}
