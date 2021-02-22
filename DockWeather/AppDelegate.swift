//
//  Created by Werner Freytag on 22.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    lazy var weatherUpdater = OpenWeatherUpdater()
    lazy var locationUpdater = LocationUpdater()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        weatherUpdater.startUpdating()
        locationUpdater.startUpdating()
        NSApp.dockTile.contentView = DockTileContentView(frame: .zero)
    }
}
