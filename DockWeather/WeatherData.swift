//
//  Created by Werner on 22.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import Foundation

struct WeatherData {
    let condition: WeatherCondition
    let daytime: Daytime

    let name: String

    let datetime: Date
    let datetimeRange: Range<Date>

    let temperature: Double
    let temperatureRange: Range<Double>
}

enum WeatherCondition {
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

enum Daytime {
    case day
    case night
}
