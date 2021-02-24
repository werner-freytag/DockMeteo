//
//  Created by Werner on 22.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import Foundation

class WeatherData: ObservableObject {
    init(condition: Condition? = nil, daytime: Daytime = .day, name: String? = nil, datetime: Date? = nil, datetimeRange: Range<Date>? = nil, temperature: Double? = nil, temperatureRange: Range<Double>? = nil) {
        self.condition = condition
        self.daytime = daytime
        self.name = name
        self.datetime = datetime
        self.datetimeRange = datetimeRange
        self.temperature = temperature
        self.temperatureRange = temperatureRange
    }

    @Published var condition: Condition?
    @Published var daytime: Daytime?

    @Published var name: String?

    @Published var datetime: Date?
    @Published var datetimeRange: Range<Date>?

    @Published var temperature: Double?
    @Published var temperatureRange: Range<Double>?

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

    enum Daytime {
        case day
        case night
    }
}
