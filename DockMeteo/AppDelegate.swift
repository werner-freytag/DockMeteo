//
//  Created by Werner Freytag on 22.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import Cocoa
import Combine
import CoreLocation

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

    private lazy var locationProvider = LocationProvider.shared
        .startUpdating()
        .throttle(for: 10, scheduler: RunLoop.main, latest: true)
        .compactMap { $0.last }
        .eraseToAnyPublisher()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let placemark = UserDefaults.standard.lastPlacemark {
            weatherProvider.location = placemark.location
            assignPlacemark(placemark)
        }

        locationProvider
            .sink(receiveCompletion: {
                if case let .failure(error) = $0, self.weatherProvider.location == nil {
                    self.handleLocationAuthorizationError(error)
                }
            }, receiveValue: {
                self.weatherProvider.location = $0

                CLGeocoder().reverseGeocodeLocation($0, completionHandler: { placemarks, error in
                    self.assignPlacemark(placemarks?.first)
                    if let lastPlacemark = placemarks?.first {
                        UserDefaults.standard.lastPlacemark = lastPlacemark
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

    private func assignPlacemark(_ placemark: CLPlacemark?) {
        contentView.placemark = placemark
        dockMenuProvider.placemark = placemark

        if let placemark = placemark {
            NSLog("Placemark: \(placemark)\n")
        }
    }
}

private extension CLLocation {
    convenience init(_ latitude: Double, _ longitude: Double) {
        self.init(latitude: latitude, longitude: longitude)
    }
}

private extension UserDefaults {
    var lastPlacemark: CLPlacemark? {
        get {
            guard let data = UserDefaults.standard.object(forKey: .lastPlacemark) as? Data else { return nil }
            do {
                return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? CLPlacemark
            } catch {
                assertionFailure(error.localizedDescription)
                return nil
            }
        }
        set {
            do {
                guard let newValue = newValue else { assertionFailure(); return }
                let data = try NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: true)
                set(data, forKey: .lastPlacemark)
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
}

private extension String {
    static let lastPlacemark = "lastPlacemark"
}
