//
//  WeatherDetailedView.swift
//  WeatherApp
//
//  Created by Deiner Calbang on 3/21/25.
//

import SwiftUI
import Domain

struct WeatherDetailedView: View {
    var weatherData: Weather?
    var selectedCountry: String?
    @AppStorage("temperatureUnit") private var temperatureUnit: String = "metric"
    
    private var weatherStatus: String {
        return weatherData?.weather.first?.main ?? ""
    }
    
    var body: some View {
        ZStack {
            
            WeatherConditionsTypeHelper.gradient(for: WeatherConditionType(rawValue: weatherStatus) ?? .clear)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                
                if let icon = weatherData?.weather.first?.icon {
                    Image(systemName: WeatherConditionsTypeHelper.weatherIcon(for: icon))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                }
                
                let units = temperatureUnit == "metric" ? "C" : "F"
                
                Text("\(Int(weatherData?.main.temperature.value ?? 0))°\(units)")
                    .font(.system(size: 70, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(radius: 3)
                
                VStack(spacing: 5) {
                    Text(weatherData?.cityName ?? "")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text(weatherData?.countryName.isEmpty == false ? weatherData?.countryName ?? "" : selectedCountry ?? "")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Text(weatherData?.weather.first?.description.capitalized ?? "")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
                
                HStack {
                    WeatherDetailCard(title: "Pressure", value: "\(weatherData?.main.pressure.value ?? 0) hPa", icon: "gauge.medium")
                    WeatherDetailCard(title: "Humidity", value: "\(weatherData?.main.humidity.value ?? 0)%", icon: "humidity")
                    WeatherDetailCard(title: "Wind", value: "\(weatherData?.wind.speed.value ?? 0.0) m/s", icon: "wind")
                }
                .padding(.top, 10)
            }
        }
    }
}

//MARK: - Detail Card View
struct WeatherDetailCard: View {
    var title: String
    var value: String
    var icon: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.white)
            Text(value)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.white)
            Text(title)
                .font(.footnote)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(width: 100, height: 100)
        .background(Color.white.opacity(0.2))
        .cornerRadius(6)
        .shadow(radius: 5)
    }
}

#Preview {
    WeatherDetailedView(weatherData: nil)
}
