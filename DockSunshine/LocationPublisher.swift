//
//  Created by Werner on 22.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import Combine
import CoreLocation
import Foundation

class LocationPublisher: NSObject {
    private let locationSubject = PassthroughSubject<[CLLocation], Error>()

    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        return manager
    }()

    func startUpdating() -> AnyPublisher<[CLLocation], Error> {
        locationManager.startUpdatingLocation()
        return locationSubject.eraseToAnyPublisher()
    }
}

extension LocationPublisher: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationSubject.send(locations)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied || manager.authorizationStatus == .restricted {
            locationSubject.send(completion: .failure(.authorizationFailed))
        }
    }

    enum Error: Swift.Error {
        case authorizationFailed
    }
}
