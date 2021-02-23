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
        weatherPublisher
            .startUpdating()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { weatherData in
                if let contentView = (NSApp.dockTile.contentView as? NSHostingView<DockTileContentView>)?.rootView {
                    contentView.weatherData = weatherData
                } else {
                    NSApp.dockTile.contentView = NSHostingView(rootView: DockTileContentView(weatherData: weatherData))
                }
                NSApp.dockTile.display()
            })
            .store(in: &cancellable)
    }
}
