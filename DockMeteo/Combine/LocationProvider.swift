//
//  Created by Werner on 22.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import CoreLocation
import Foundation

class LocationProvider: NSObject {
    static let shared = LocationProvider()

    private var continuation: AsyncThrowingStream<CLLocation, Error>.Continuation?

    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.distanceFilter = 500
        manager.delegate = self
        return manager
    }()

    func locations() -> AsyncThrowingStream<CLLocation, Error> {
        AsyncThrowingStream { continuation in
            self.continuation = continuation
            self.locationManager.startUpdatingLocation()
        }
    }

    enum LocationError: Swift.Error {
        case authorizationFailed
    }
}

extension LocationProvider: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        continuation?.yield(location)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied || manager.authorizationStatus == .restricted {
            continuation?.finish(throwing: LocationError.authorizationFailed)
        }
    }
}
