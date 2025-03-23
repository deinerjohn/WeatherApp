//
//  WeatherLoadingView.swift
//  WeatherApp
//
//  Created by Deiner Calbang on 3/24/25.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let animationName: String

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let lottieAnimationView = LottieAnimationView(name: animationName)
        lottieAnimationView.contentMode = .scaleAspectFit
        lottieAnimationView.loopMode = .loop
        lottieAnimationView.play()
        lottieAnimationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lottieAnimationView)
        NSLayoutConstraint.activate([
            lottieAnimationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            lottieAnimationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) { }
}

struct WeatherLoadingView: View {
    var body: some View {
        VStack {
            LottieView(animationName: "weather_loading")
                .frame(maxWidth: 120, maxHeight: 120)
                .padding()
        }
    }
}
