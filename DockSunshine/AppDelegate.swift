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

    private lazy var contentView: DockTileContentView = {
        var objects: NSArray!
        Bundle.main.loadNibNamed("DockTileContentView", owner: nil, topLevelObjects: &objects)
        return objects.first(where: { type(of: $0) == DockTileContentView.self }) as! DockTileContentView
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.dockTile.contentView = contentView

        weatherPublisher
            .startUpdating()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [contentView] weatherData in
                contentView.weatherData = weatherData
                NSApp.dockTile.display()
            })
            .store(in: &cancellable)
    }
}
