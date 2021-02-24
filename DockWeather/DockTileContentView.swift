//
//  Created by Werner on 23.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import SwiftUI

struct DockTileContentView: View {
    @State var weatherData: WeatherData

    var body: some View {
        ZStack {
            Image(weatherData.image)
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                            .frame(width: weatherData.temperature.rounded() < 0 ? 0 : 6.0)
                            .background(Color.black)
                        Text("\(Int(weatherData.temperature.rounded()))º")
                            .font(.system(size: 36, weight: .light, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.white)
                            .shadow(color: Color(weatherData.shadowColor), radius: 5, x: 0, y: 1)
                        Spacer()
                            .frame(width: weatherData.temperature.rounded() < 0 ? 10 : 0)
                            .background(Color.black)
                    }
                    Spacer()
                        .frame(width: 1, height: 6.0)
                }
                VStack {
                    Spacer()
                    Text(weatherData.name)
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
    }
}

extension WeatherData {
    private func applyDaytime(to string: String) -> String {
        daytime == .day ? string : "\(string)_Night"
    }
    
    var shadowColor: String {
        applyDaytime(to: "TextShadowColor")
    }
    
    var image: String {
        switch condition {
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
        }
    }
}

struct DockTileContentView_Previews: PreviewProvider {
    static var previews: some View {
        DockTileContentView(weatherData: WeatherData(condition: .clearSky, daytime: .day, name: "Garmisch-Partenkirchen", datetime: Date(timeIntervalSince1970: 1_614_095_412), datetimeRange: Date(timeIntervalSince1970: 1_614_060_418) ..< Date(timeIntervalSince1970: 1_614_098_926), temperature: 13.58, temperatureRange: 11.67 ..< 15))
            .frame(width: 128.0, height: 128.0)
    }
}
