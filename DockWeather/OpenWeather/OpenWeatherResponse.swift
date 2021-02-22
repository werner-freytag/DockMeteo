//
//  Created by Werner Freytag on 22.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import Foundation

struct OpenWeatherResponse: Codable {
    struct Coord: Codable {
        let lon: Double
        let lat: Double
    }

    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: Icon
    }

    enum Icon: String, Codable {
        case clearSky_Day = "01d"
        case clearSky_Night = "01n"
        case fewClouds_Day = "02d"
        case fewClouds_Night = "02n"
        case scatteredClouds_Day = "03d"
        case scatteredClouds_Night = "03n"
        case brokenClouds_Day = "04d"
        case brokenClouds_Night = "04n"
        case showerRain_Day = "09d"
        case showerRain_Night = "09n"
        case rain_Day = "10d"
        case rain_Night = "10n"
        case thunderstorm_Day = "11d"
        case thunderstorm_Night = "11n"
        case snow_Day = "13d"
        case snow_Night = "13n"
        case mist_Day = "50d"
        case mist_Night = "50n"
    }

    struct Main: Codable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let humidity: Int
    }

    struct Wind: Codable {
        let speed: Double
        let deg: Int
    }

    struct Clouds: Codable {
        let all: Int
    }

    struct Sys: Codable {
        let country: String
        let sunrise: TimeInterval
        let sunset: TimeInterval
    }

    let coord: Coord
    let weather: [Weather]
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: TimeInterval
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
}
