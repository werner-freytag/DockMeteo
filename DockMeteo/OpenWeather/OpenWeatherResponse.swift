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
        let id: WeatherID
        let main: String
        let description: String
        let icon: Icon
    }

    enum WeatherID: Int, Codable {
        case thunderstormWithLightRain = 200
        case thunderstormWithRain = 201
        case thunderstormWithHeavyRain = 202
        case lightThunderstorm = 210
        case thunderstorm = 211
        case heavyThunderstorm = 212
        case raggedThunderstorm = 221
        case thunderstormWithLightDrizzle = 230
        case thunderstormWithDrizzle = 231
        case thunderstormWithHeavyDrizzle = 232
        case lightIntensityDrizzle = 300
        case drizzle = 301
        case heavyIntensityDrizzle = 302
        case lightIntensityDrizzleRain = 310
        case drizzleRain = 311
        case heavyIntensityDrizzleRain = 312
        case showerRainAndDrizzle = 313
        case heavyShowerRainAndDrizzle = 314
        case showerDrizzle = 321
        case lightRain = 500
        case moderateRain = 501
        case heavyIntensityRain = 502
        case veryHeavyRain = 503
        case extremeRain = 504
        case freezingRain = 511
        case lightIntensityShowerRain = 520
        case showerRain = 521
        case heavyIntensityShowerRain = 522
        case raggedShowerRain = 531
        case lightSnow = 600
        case snow = 601
        case heavySnow = 602
        case sleet = 611
        case lightShowerSleet = 612
        case showerSleet = 613
        case lightRainAndSnow = 615
        case rainAndSnow = 616
        case lightShowerSnow = 620
        case showerSnow = 621
        case heavyShowerSnow = 622
        case mist = 701
        case smoke = 711
        case haze = 721
        case sandDustWhirls = 731
        case fog = 741
        case sand = 751
        case dust = 761
        case volcanicAsh = 762
        case squalls = 771
        case tornado = 781
        case clearSky = 800
        case fewClouds = 801
        case scatteredClouds = 802
        case brokenClouds = 803
        case overcastClouds = 804
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
