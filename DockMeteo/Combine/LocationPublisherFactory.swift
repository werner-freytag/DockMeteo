//
//  Created by Werner on 22.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import Combine
import CoreLocation
import Foundation

class LocationPublisherFactory: NSObject {
    static let shared = LocationPublisherFactory()

    private let subject = PassthroughSubject<[CLLocation], Error>()

    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.delegate = self
        return manager
    }()

    func startUpdating() -> AnyPublisher<[CLLocation], Error> {
        locationManager.startUpdatingLocation()
        return subject.eraseToAnyPublisher()
    }
}

extension LocationPublisherFactory: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        subject.send(locations)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied || manager.authorizationStatus == .restricted {
            subject.send(completion: .failure(.authorizationFailed))
        }
    }

    enum Error: Swift.Error {
        case authorizationFailed
    }
}
