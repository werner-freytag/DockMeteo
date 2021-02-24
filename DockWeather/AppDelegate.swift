//
//  Created by Werner Freytag on 22.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import Cocoa
import Combine
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    private lazy var weatherPublisher = OpenWeatherPublisher()
    private var cancellable = Set<AnyCancellable>()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let contentView = DockTileContentView(weatherData: WeatherData())
        NSApp.dockTile.contentView = NSHostingView(rootView: contentView)

        weatherPublisher
            .startUpdating()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { weatherData in
                contentView.weatherData.condition = weatherData.condition
                contentView.weatherData.daytime = weatherData.daytime
                contentView.weatherData.name = weatherData.name
                contentView.weatherData.datetime = weatherData.datetime
                contentView.weatherData.datetimeRange = weatherData.datetimeRange
                contentView.weatherData.temperature = weatherData.temperature
                contentView.weatherData.temperatureRange = weatherData.temperatureRange
                NSApp.dockTile.display()
            })
            .store(in: &cancellable)
    }
}
