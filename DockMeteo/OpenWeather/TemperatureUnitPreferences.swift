//
//  Created by Werner Freytag on 22.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import Foundation

enum TemperatureUnitPreferences {
    case celsius
    case fahrenheit

    init() throws {
        let key = "AppleTemperatureUnit" as CFString
        let domain = "Apple Global Domain" as CFString

        guard let unit = CFPreferencesCopyValue(key, domain, kCFPreferencesCurrentUser, kCFPreferencesAnyHost) as? String else {
            throw Error.TemperatureUnitNotFound
        }

        switch unit {
        case "Celsius":
            self = .celsius
        case "Fahrenheit":
            self = .fahrenheit
        default:
            throw Error.UnknownTemperatureUnit(unit)
        }
    }
}

enum Error: Swift.Error {
    case TemperatureUnitNotFound
    case UnknownTemperatureUnit(String)
}
