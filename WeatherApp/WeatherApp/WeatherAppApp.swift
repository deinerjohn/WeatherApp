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
    
    private let appDIContainer = AppDIContainer.shared
    @State private var isShowSplashScreen: Bool = true
    
    var body: some Scene {
        WindowGroup {
            
            Group {
                if isShowSplashScreen {
                    SplashScreenView(isShowSplash: $isShowSplashScreen)
                } else {
                    WeatherMainView(viewModel: appDIContainer.makeWeatherMainViewModel())
                }
            }
            
        }
    }
}
