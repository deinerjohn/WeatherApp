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
    
    @Namespace private var animationNamespace
    @State private var selectedWeather: Weather?
    @State private var isShowDetails: Bool = false
    
    var body: some View {
        ZStack {
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
                            
                            if viewModel.searchValue.isEmpty {
                                List {
                                    ForEach(viewModel.weatherListData) { weather in
                                        Button(action: {
                                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.3)) {
                                                selectedWeather = weather
                                                isShowDetails = true
                                            }
                                        }) {
                                            WeatherRowView(weatherData: weather)
                                                .matchedGeometryEffect(id: weather.countryName, in: animationNamespace)
                                        }
                                        .listRowBackground(Color.clear)
                                        .listRowSeparator(.hidden)
                                        
                                    }
                                    .onDelete(perform: viewModel.deleteWeatherData)
                                    .onMove(perform: moveItem)
                                    
                                }
                                .listStyle(.plain)
                                .background(.clear)
       
                            }
                            
                        }
                        
                    }
                    .navigationTitle("Weather Demo App")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu {
                                Button(action: {
                                    self.viewModel.temperatureUnit = "metric"
                                    self.viewModel.updateAndReloadAllCachedWeather(units: "metric")
                                }) {
                                    Label("Metric", systemImage: self.viewModel.temperatureUnit == "metric" ? "checkmark" : "")
                                }
                                
                                Button(action: {
                                    self.viewModel.temperatureUnit = "imperial"
                                    self.viewModel.updateAndReloadAllCachedWeather(units: "imperial")
                                }) {
                                    Label("Imperial", systemImage: self.viewModel.temperatureUnit == "imperial" ? "checkmark" : "")
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
                
            }
            .scaleEffect(isShowDetails ? 0.9 : 1)
            .animation(.spring(), value: isShowDetails)
            
            if let selectedWeather, isShowDetails {
                WeatherDetailedView(
                    weatherData: selectedWeather,
                    selectedCountry: viewModel.selectedCountry?.country,
                    isPresented: $isShowDetails,
                    namespace: animationNamespace
                )
                .onDisappear {
                    self.selectedWeather = nil
                }
            } else if let fetchedWeather = viewModel.selectedCountryWeatherData, viewModel.showDetailWeather {
                WeatherDetailedView(
                    weatherData: fetchedWeather,
                    selectedCountry: viewModel.selectedCountry?.country,
                    isPresented: $viewModel.showDetailWeather,
                    namespace: animationNamespace
                )
                .onDisappear {
                    self.viewModel.selectedCountryWeatherData = nil
                }
            }
            
            if viewModel.isLoading {
                WeatherLoadingView()
            }
            
        }
        .onAppear {
            self.viewModel.loadWeatherData()
        }
    }
    
    private func moveItem(from source: IndexSet, to destination: Int) {
        viewModel.weatherListData.move(fromOffsets: source, toOffset: destination)
    }
}
