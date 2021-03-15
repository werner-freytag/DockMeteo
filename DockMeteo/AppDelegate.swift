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

    private var location: CLLocation?

    private var locationPublisher: AnyPublisher<CLLocation, LocationPublisherFactory.Error> {
        if let location = location {
            return Just(location)
                .setFailureType(to: LocationPublisherFactory.Error.self)
                .eraseToAnyPublisher()
        }

        return LocationPublisherFactory.shared
            .startUpdating()
            .throttle(for: 10, scheduler: RunLoop.main, latest: true)
            .compactMap { $0.last }
            .eraseToAnyPublisher()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        locationPublisher
            .sink(receiveCompletion: {
                if case let .failure(error) = $0, self.weatherPublisher.location == nil {
                    self.handleLocationAuthorizationError(error)
                }
            }, receiveValue: {
                self.weatherPublisher.location = $0

                CLGeocoder().reverseGeocodeLocation($0, completionHandler: { placemarks, error in
                    self.contentView.placemark = placemarks?.first

                    if let placemark = placemarks?.first {
                        NSLog("Placemark: \(placemark)\n")
                    }
                })
            })
            .store(in: &cancellable)

        weatherPublisher
            .startUpdating()
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .sink(receiveValue: { [contentView] weatherData in
                contentView.weatherData = weatherData
                NSApp.dockTile.contentView = contentView
                NSApp.dockTile.display()
            })
            .store(in: &cancellable)
    }

    private func handleLocationAuthorizationError(_ error: LocationPublisherFactory.Error) {
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("Location services are not enabled.", comment: "Alert title")
        alert.addButton(withTitle: NSLocalizedString("Quit DockMeteo", comment: "Alert button"))
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
