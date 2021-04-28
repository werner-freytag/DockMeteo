//
//  Created by Werner on 22.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import Foundation
import SwiftToolbox

struct WeatherData {
    let condition: Condition
    let temperature: Double

    let location: Location
    let date: Date
    let isNight: Bool?

    let details: Details?

    struct Details {
        struct Wind {
            let speed: Double
            let direction: SkyDirection
        }

        init(conditionDescription: String? = nil, temperatureFelt: Double? = nil, pressure: Int? = nil, humidity: Int? = nil, visibility: Int? = nil, wind: Wind? = nil, clouds: Int? = nil) {
            self.conditionDescription = conditionDescription
            self.temperatureFelt = temperatureFelt
            self.pressure = pressure
            self.humidity = humidity
            self.visibility = visibility
            self.wind = wind
            self.clouds = clouds
        }

        let conditionDescription: String?
        let temperatureFelt: Double?
        let pressure: Int?
        let humidity: Int?
        let visibility: Int?
        let wind: Wind?
        let clouds: Int?
    }

    struct Location {
        var name: String
        let coordinate: Coordinate

        struct Coordinate {
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

extension WeatherData: Equatable {}

extension WeatherData.Location: Equatable {}

extension WeatherData.Location.Coordinate: Equatable {}

extension WeatherData.Details: Equatable {}

extension WeatherData.Details.Wind: Equatable {}
