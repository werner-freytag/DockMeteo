//
//  Created by Werner on 22.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import Foundation

struct WeatherData {
    init(condition: Condition? = nil, temperature: Double? = nil, location: Location? = nil, date: Date? = nil) {
        self.condition = condition
        self.temperature = temperature

        self.location = location
        self.date = date
    }

    let condition: Condition?
    let temperature: Double?

    let location: Location?
    let date: Date?

    struct Location {
        var name: String?
        let coordinate: Coordinate

        struct Coordinate: Equatable {
            let latitude: Double
            let longitude: Double
        }
    }

    enum Condition {
        case clearSky
        case fewClouds
        case scatteredClouds
        case brokenClouds
        case showerRain
        case rain
        case thunderstorm
        case snow
        case mist
    }
}
