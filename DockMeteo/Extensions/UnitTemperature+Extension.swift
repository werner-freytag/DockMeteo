//
//  Created by Werner Freytag on 22.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import Foundation

extension UnitTemperature {
    static var `default`: UnitTemperature? {
        let key = "AppleTemperatureUnit" as CFString
        let domain = "Apple Global Domain" as CFString

        guard let unit = CFPreferencesCopyValue(key, domain, kCFPreferencesCurrentUser, kCFPreferencesAnyHost) as? String else {
            return nil
        }

        switch unit {
        case "Celsius":
            return .celsius
        case "Fahrenheit":
            return .fahrenheit
        default:
            return nil
        }
    }
}
