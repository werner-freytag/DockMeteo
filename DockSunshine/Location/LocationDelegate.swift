//
//  Created by Werner Freytag on 22.02.21.
//

import AppKit
import CoreLocation

class LocationDelegate: NSObject, CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        NotificationCenter.default.post(Notification(name: Notification.Name.Location.didUpdate, object: self, userInfo: ["locations": locations]))
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard manager.authorizationStatus != .denied, manager.authorizationStatus != .restricted else {
            let alert = NSAlert()
            alert.messageText = "Location services are not enabled."
            alert.addButton(withTitle: "Quit DockWeather")
            alert.addButton(withTitle: "Open Preferences")

            let workspace = NSWorkspace.shared
            switch alert.runModal() {
            case .alertFirstButtonReturn:
                NSApp.terminate(self)
            default:
                workspace.open(URL(fileURLWithPath: "x-apple.systempreferences:com.apple.preference.security"))
                workspace.open(URL(fileURLWithPath: "x-apple.systempreferences:com.apple.preference.security?Privacy_LocationServices"))
            }

            return
        }
    }
}
