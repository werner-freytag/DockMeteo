//
//  Created by Werner Freytag on 22.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import Cocoa
import Combine
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    private lazy var locationPublisher = LocationPublisher()
    private lazy var weatherPublisher = OpenWeatherPublisher()
    private var cancellable = Set<AnyCancellable>()

    private lazy var contentView: DockTileContentView = {
        var objects: NSArray!
        Bundle.main.loadNibNamed("DockTileContentView", owner: nil, topLevelObjects: &objects)
        return objects.first(where: { type(of: $0) == DockTileContentView.self }) as! DockTileContentView
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        locationPublisher
            .startUpdating()
            .throttle(for: 10, scheduler: RunLoop.main, latest: true)
            .sink(receiveCompletion: {
                if case let .failure(error) = $0, self.weatherPublisher.location == nil {
                    self.handleLocationAuthorizationError(error)
                }
            }, receiveValue: { locations in
                self.weatherPublisher.location = locations.last
            })
            .store(in: &cancellable)

        weatherPublisher
            .startUpdating()
            .receive(on: RunLoop.main)
            .filter { $0.condition != nil }
            .sink(receiveValue: { [contentView] weatherData in
                contentView.weatherData = weatherData
                NSApp.dockTile.contentView = contentView
                NSApp.dockTile.display()
            })
            .store(in: &cancellable)
    }

    private func handleLocationAuthorizationError(_ error: LocationPublisher.Error) {
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("Location services are not enabled.", comment: "Alert title")
        alert.addButton(withTitle: NSLocalizedString("Quit DockSunshine", comment: "Alert button"))
        alert.addButton(withTitle: NSLocalizedString("Open Preferences", comment: "Alert button"))

        let workspace = NSWorkspace.shared
        switch alert.runModal() {
        case .alertFirstButtonReturn:
            NSApp.terminate(self)
        default:
            workspace.open(URL(fileURLWithPath: "x-apple.systempreferences:com.apple.preference.security"))
            workspace.open(URL(fileURLWithPath: "x-apple.systempreferences:com.apple.preference.security?Privacy_LocationServices"))
        }
    }
}
