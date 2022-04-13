//
//  Created by Werner Freytag on 22.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import Cocoa
import Combine
import CoreLocation
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    private lazy var weatherProvider = OpenWeatherProvider()
    private lazy var dockMenuProvider = DockMenuProvider()

    private var cancellable = Set<AnyCancellable>()

    private lazy var contentView: DockTileContentView = {
        var objects: NSArray!
        Bundle.main.loadNibNamed("DockTileContentView", owner: nil, topLevelObjects: &objects)
        return objects.first(where: { type(of: $0) == DockTileContentView.self }) as! DockTileContentView
    }()

    private var specifiedLocation: CLLocation?

    private var locationProvider: AnyPublisher<CLLocation, LocationProvider.Error> {
        if let specifiedLocation = specifiedLocation {
            return Just(specifiedLocation)
                .setFailureType(to: LocationProvider.Error.self)
                .eraseToAnyPublisher()
        }

        return LocationProvider.shared
            .startUpdating()
            .throttle(for: 10, scheduler: RunLoop.main, latest: true)
            .compactMap { $0.last }
            .eraseToAnyPublisher()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        locationProvider
            .sink(receiveCompletion: {
                if case let .failure(error) = $0, self.weatherProvider.location == nil {
                    self.handleLocationAuthorizationError(error)
                }
            }, receiveValue: {
                self.weatherProvider.location = $0

                CLGeocoder().reverseGeocodeLocation($0, completionHandler: { placemarks, error in
                    self.contentView.placemark = placemarks?.first
                    self.dockMenuProvider.placemark = placemarks?.first

                    if let placemark = placemarks?.first {
                        NSLog("Placemark: \(placemark)\n")
                    }
                })
            })
            .store(in: &cancellable)

        weatherProvider
            .startUpdating()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { weatherData in
                self.contentView.weatherData = weatherData
                self.dockMenuProvider.weatherData = weatherData
                NSApp.dockTile.contentView = self.contentView
                NSApp.dockTile.display()
            })
            .store(in: &cancellable)
    }

    func applicationDockMenu(_: NSApplication) -> NSMenu? {
        dockMenuProvider.menu
    }

    private func handleLocationAuthorizationError(_ error: LocationProvider.Error) {
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

private extension CLLocation {
    convenience init(_ latitude: Double, _ longitude: Double) {
        self.init(latitude: latitude, longitude: longitude)
    }
}
