//
//  WeatherRowView.swift
//  WeatherApp
//
//  Created by Deiner Calbang on 3/21/25.
//

import SwiftUI
import Domain

struct WeatherRowView: View {
    
    var weatherData: Weather
    @AppStorage("temperatureUnit") private var temperatureUnit: String = "metric"
    
    var body: some View {
        ZStack {
            WeatherConditionsTypeHelper.gradient(for: WeatherConditionType(rawValue: weatherData.weather.first?.main ?? "") ?? .clear)
                .cornerRadius(10)
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    
                    Text("\(weatherData.cityName ?? "-"), \(weatherData.countryName)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    let units = temperatureUnit == "metric" ? "C" : "F"
                    
                    Text("\(Int(weatherData.main.temperature.value))° \(units)")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Image(systemName: WeatherConditionsTypeHelper.weatherIcon(for: weatherData.weather.first?.icon ?? ""))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
            }
            .padding()
        }
        .frame(height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 5)
    }
}
