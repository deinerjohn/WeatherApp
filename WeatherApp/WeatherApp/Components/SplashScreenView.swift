//
//  SplashScreen.swift
//  WeatherApp
//
//  Created by Deiner Calbang on 3/25/25.
//

import SwiftUI

struct SplashScreenView: View {
    
    @Binding var isShowSplash: Bool
    @State private var isAnimating = true
    
    var body: some View {
        ZStack {
            LottieView(animationName: "weather_loading", loopMode: .loop)
                .frame(width: 250, height: 250)
        }
        .frame(width: 250, height: 250)
        .opacity(isAnimating ? 1 : 0)
        .animation(.easeOut(duration: 1.5), value: isAnimating)
        .task {
            await self.fadingOutSplash()
        }
    }
    
    private func fadingOutSplash() async {
         try? await Task.sleep(nanoseconds: 2_700_000_000) // Wait for 2.7 sec
         withAnimation {
             isAnimating = false
         }
         try? await Task.sleep(nanoseconds: 1_300_000_000) // Fade out over 1.3 sec
         withAnimation {
             isShowSplash = false
         }
     }
    
}
