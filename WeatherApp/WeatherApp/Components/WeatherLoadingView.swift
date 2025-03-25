//
//  WeatherLoadingView.swift
//  WeatherApp
//
//  Created by Deiner Calbang on 3/24/25.
//

import SwiftUI

struct WeatherLoadingView: View {
    var body: some View {
        ZStack {
            
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .blur(radius: 10)
            
            LottieView(animationName: "weather_loading")
                .frame(maxWidth: 120, maxHeight: 120)
                .padding()
        }
    }
}
