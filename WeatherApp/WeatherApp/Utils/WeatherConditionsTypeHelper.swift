//
//  WeatherConditionsTypeHelper.swift
//  WeatherApp
//
//  Created by Deiner Calbang on 3/23/25.
//

import SwiftUI
import Domain

struct WeatherConditionsTypeHelper {
    
    static func gradient(for condition: WeatherConditionType) -> LinearGradient {
        switch condition {
        case .clear:
            return LinearGradient(colors: [Color.blue, Color.cyan], startPoint: .top, endPoint: .bottom)
        case .clouds:
            return LinearGradient(colors: [Color.gray.opacity(0.8), Color.white], startPoint: .top, endPoint: .bottom)
        case .rain:
            return LinearGradient(colors: [Color.gray, Color.blue.opacity(0.6)], startPoint: .top, endPoint: .bottom)
        case .drizzle:
            return LinearGradient(colors: [Color.gray.opacity(0.7), Color.blue.opacity(0.5)], startPoint: .top, endPoint: .bottom)
        case .thunderstorm:
            return LinearGradient(colors: [Color.black, Color.gray.opacity(0.8)], startPoint: .top, endPoint: .bottom)
        case .snow:
            return LinearGradient(colors: [Color.white, Color.blue.opacity(0.4)], startPoint: .top, endPoint: .bottom)
        case .mist, .fog:
            return LinearGradient(colors: [Color.gray.opacity(0.5), Color.white.opacity(0.8)], startPoint: .top, endPoint: .bottom)
        case .smoke:
            return LinearGradient(colors: [Color.gray.opacity(0.6), Color.black.opacity(0.4)], startPoint: .top, endPoint: .bottom)
        case .sand:
            return LinearGradient(colors: [Color.brown, Color.orange.opacity(0.6)], startPoint: .top, endPoint: .bottom)
        }
    }
    
    static func primaryTintColor(for condition: WeatherConditionType) -> Color {
        switch condition {
        case .clear:
            return .blue
        case .clouds:
            return .gray
        case .rain, .drizzle:
            return .cyan
        case .thunderstorm:
            return .purple
        case .snow:
            return .white
        case .mist, .fog:
            return .gray
        case .smoke, .sand:
            return .brown
        }
    }
    
    static func weatherIcon(for code: String) -> String {
        switch code {
            
        case "01d", "01n": 
            return "sun.max.fill"
        case "02d", "02n": 
            return "cloud.sun.fill"
        case "03d", "03n":
            return "cloud.fill"
        case "04d", "04n":
            return "smoke.fill"
        case "09d", "09n":
            return "cloud.drizzle.fill"
        case "10d", "10n":
            return "cloud.rain.fill"
        case "11d", "11n":
            return "cloud.bolt.fill"
        case "13d", "13n":
            return "snowflake"
        case "50d", "50n":
            return "cloud.fog.fill"
        default: 
            return "questionmark.circle.fill"
            
        }
    }
    
}
