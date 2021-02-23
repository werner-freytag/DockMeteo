//
//  Created by Werner on 23.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import SwiftUI

struct DockTileContentView: View {
    @State var weatherData: WeatherData?

    var body: some View {
        if let weatherData = weatherData {
            ZStack {
                Image("BrokenClouds")
                Text("\(Int(weatherData.temperature.rounded()))º")
                    .font(.title)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct DockTileContentView_Previews: PreviewProvider {
    static var previews: some View {
        DockTileContentView(weatherData: WeatherData(condition: .clearSky, daytime: .day, name: "Krailling", datetime: Date(timeIntervalSince1970: 1_614_095_412), datetimeRange: Date(timeIntervalSince1970: 1_614_060_418) ..< Date(timeIntervalSince1970: 1_614_098_926), temperature: 13.98, temperatureRange: 11.67 ..< 15))
            .frame(width: 128.0, height: 128.0)
    }
}
