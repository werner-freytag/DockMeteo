//
//  Created by Werner on 23.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import SwiftUI

struct DockTileContentView: View {
    @ObservedObject var weatherData: WeatherData

    var body: some View {
        ZStack {
            Image(image)
            if let temperature = weatherData.temperature?.rounded() {
                VStack {
                    HStack {
                        Spacer()
                            .frame(width: 6.0)
                        Text("\(Int(temperature))º")
                            .font(.system(size: 36, weight: .light, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.white)
                            .shadow(color: Color(self.textShadowColor), radius: 5, x: 0, y: 1)
                        if temperature < 0 {
                            Spacer()
                                .frame(width: 16)
                        }
                    }
                    Spacer()
                        .frame(height: 6.0)
                }
            }
            if let name = weatherData.name {
                VStack {
                    Spacer()
                    Text(name)
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .frame(width: 94.0, height: 35.0)
                        .foregroundColor(Color.white)
                        .opacity(0.75)
                    Spacer()
                        .frame(height: 17.0)
                }
            }
        }
        .frame(width: 128.0, height: 128.0)
    }

    private func applyDaytime(to string: String) -> String {
        weatherData.daytime == .night ? "\(string)_Night" : string
    }

    private var textShadowColor: String {
        applyDaytime(to: "TextShadowColor")
    }

    private var image: String {
        switch weatherData.condition {
        case .clearSky:
            return applyDaytime(to: "Clear")
        case .fewClouds:
            return applyDaytime(to: "FewClouds")
        case .scatteredClouds:
            return applyDaytime(to: "ScatteredClouds")
        case .brokenClouds:
            return applyDaytime(to: "BrokenClouds")
        case .showerRain:
            return applyDaytime(to: "ShowerRain")
        case .rain:
            return applyDaytime(to: "Rain")
        case .thunderstorm:
            return applyDaytime(to: "Thunderstorm")
        case .snow:
            return applyDaytime(to: "Snow")
        case .mist:
            return applyDaytime(to: "Mist")
        case .none:
            return "Placeholder"
        }
    }
}

struct DockTileContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DockTileContentView(weatherData: WeatherData(condition: .clearSky, daytime: .day, name: "Paris", temperature: 14))
            DockTileContentView(weatherData: WeatherData(condition: .fewClouds, daytime: .night, name: "San Francisco", temperature: 47))
        }
    }
}
