//
//  Created by Werner on 22.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import CoreLocation
import Foundation

class LocationUpdater {
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = LocationDelegate.shared

        return manager
    }()

    func startUpdating() {
        locationManager.startUpdatingLocation()
    }
}

public extension Notification.Name {
    enum Location {
        public static let didUpdate = Notification.Name(rawValue: "Location.didUpdate")
    }
}
