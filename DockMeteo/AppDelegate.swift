//
//  Created by Werner Freytag on 22.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import Cocoa
import CoreLocation

@MainActor
@main
class AppDelegate: NSObject, NSApplicationDelegate {
    private let weatherProvider = OpenWeatherProvider()
    private lazy var dockMenuProvider = DockMenuProvider()

    private lazy var contentView: DockTileContentView = {
        var objects: NSArray!
        Bundle.main.loadNibNamed("DockTileContentView", owner: nil, topLevelObjects: &objects)
        return objects.first(where: { type(of: $0) == DockTileContentView.self }) as! DockTileContentView
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        Task {
            let weatherStream = weatherProvider.startUpdating()

            if let placemark = UserDefaults.standard.lastPlacemark {
                if let location = placemark.location {
                    await weatherProvider.update(location: location)
                }
                assignPlacemark(placemark)
            }

            Task {
                for await weatherData in weatherStream {
                    contentView.weatherData = weatherData
                    dockMenuProvider.weatherData = weatherData
                    NSApp.dockTile.contentView = contentView
                    NSApp.dockTile.display()
                }
            }

            Task {
                do {
                    for try await location in LocationProvider.shared.locations() {
                        await weatherProvider.update(location: location)
                        if let placemark = await reverseGeocode(location) {
                            assignPlacemark(placemark)
                            UserDefaults.standard.lastPlacemark = placemark
                        }
                    }
                } catch {
                    if weatherProvider.location == nil {
                        handleLocationAuthorizationError()
                    }
                }
            }
        }
    }

    func applicationDockMenu(_: NSApplication) -> NSMenu? {
        dockMenuProvider.menu
    }

    private func reverseGeocode(_ location: CLLocation) async -> CLPlacemark? {
        await withCheckedContinuation { continuation in
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, _ in
                continuation.resume(returning: placemarks?.first)
            }
        }
    }

    private func handleLocationAuthorizationError() {
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
        if let placemark {
            NSLog("Placemark: \(placemark)\n")
        }
    }
}

private extension UserDefaults {
    var lastPlacemark: CLPlacemark? {
        get {
            guard let data = object(forKey: .lastPlacemark) as? Data else { return nil }
            if let placemark = try? NSKeyedUnarchiver.unarchivedObject(ofClass: CLPlacemark.self, from: data) {
                return placemark
            }
            // Fallback for data archived by older app versions without secure coding
            let unarchiver = try? NSKeyedUnarchiver(forReadingFrom: data)
            unarchiver?.requiresSecureCoding = false
            defer { unarchiver?.finishDecoding() }
            return unarchiver?.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as? CLPlacemark
        }
        set {
            do {
                guard let newValue else { assertionFailure(); return }
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
