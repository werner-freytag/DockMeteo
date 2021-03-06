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
                TemperatureView(temperature: Int(temperature), textShadowColor: textShadowColor)
            }
            if let name = weatherData.name {
                NameView(name: name)
            }
        }
        .frame(width: 128.0, height: 128.0)
    }

    private func applyDaytime(to string: String) -> String {
        weatherData.daytime == .night ? "\(string)_Night" : string
    }

    private var textShadowColor: Color {
        Color(applyDaytime(to: "TextShadowColor"))
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
            DockTileContentView(weatherData: WeatherData(condition: .clearSky, name: "Paris", temperature: 32))
            DockTileContentView(weatherData: WeatherData(condition: .fewClouds, daytime: .night, name: "San Francisco", temperature: 47))
            DockTileContentView(weatherData: WeatherData(condition: .snow, name: "St. Moritz", temperature: -1))
            DockTileContentView(weatherData: WeatherData(condition: .rain, name: "London", temperature: 19))
        }
    }
}

struct NameView: View {
    var name: String
    var body: some View {
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

struct TemperatureView: View {
    var temperature: Int
    var textShadowColor: Color

    var body: some View {
        VStack {
            HStack {
                Spacer()
                    .frame(width: 6.0)
                Text("\(temperature)º")
                    .font(.system(size: 38, weight: .light, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.white)
                    .shadow(color: textShadowColor, radius: 5, x: 0, y: 1)
                if temperature < 0 {
                    Spacer()
                        .frame(width: 16)
                }
            }
            Spacer()
                .frame(height: 6.0)
        }
    }
}
