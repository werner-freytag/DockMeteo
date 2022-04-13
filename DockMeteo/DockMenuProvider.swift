//
//  Created by Werner on 18.03.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import Cocoa
import CoreLocation

class DockMenuProvider {
    var placemark: CLPlacemark?
    var weatherData: WeatherData?

    var menu: NSMenu {
        let menu = NSMenu(title: NSLocalizedString("Info", comment: "Info menu title"))

        for row in weatherDetails ?? [] {
            menu.addString(row)
        }

        return menu
    }

    var weatherDetails: [String]? {
        guard let weatherData = weatherData else { return nil }

        let details: [[String]] = [
            {
                var details: [String] = []

                if let conditionDescription = weatherData.details?.conditionDescription {
                    details.append(conditionDescription)
                }

                details.append(formatTemperature(weatherData.temperature))

                if let temperatureFelt = weatherData.details?.temperatureFelt {
                    let format = NSLocalizedString("feels like %@", comment: "Info menu: temperature felt")
                    details.append(String(format: format, formatTemperature(Double(temperatureFelt))))
                }

                return details
            }(),

            {
                var details: [String] = []

                if let pressure = weatherData.details?.pressure {
                    details.append(String(format: NSLocalizedString("pressure: %@", comment: "Info menu: pressure"), formatPressure(Double(pressure))))
                }

                if let humidity = weatherData.details?.humidity {
                    details.append(String(format: NSLocalizedString("humidity: %@", comment: "Info menu: humidity"), formatPercent(Double(humidity) / 100)))
                }

                if let visibility = weatherData.details?.visibility {
                    details.append(String(format: NSLocalizedString("visibility: %@", comment: "Info menu: visibility"), formatLength(Double(visibility))))
                }

                return details
            }(),

            {
                var details: [String] = []

                if let wind = weatherData.details?.wind {
                    details.append(String(format: NSLocalizedString("wind: %@ from %@", comment: "Info menu: wind <speed> from <direction>"),
                                          formatSpeed(Double(wind.speed)),
                                          wind.direction.description))
                }

                if let clouds = weatherData.details?.clouds {
                    details.append(String(format: NSLocalizedString("clouds: %@", comment: "Info menu: clouds"), formatPercent(Double(clouds) / 100)))
                }

                return details
            }(),
        ]

        return details.compactMap {
            guard !$0.isEmpty else { return nil }
            return $0.joined(separator: ", ").capitalizingFirstLetter
        }
    }

    private lazy var formatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0

        formatter.numberFormatter = numberFormatter
        formatter.unitStyle = .medium
        return formatter
    }()

    private lazy var percentFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        return numberFormatter
    }()

    func formatPercent(_ value: Double) -> String {
        return percentFormatter.string(from: NSNumber(value: value))!
    }

    func formatTemperature(_ value: Double, unit: UnitTemperature = .celsius) -> String {
        return formatter.string(from: Measurement<UnitTemperature>(value: Double(Int(value.rounded())), unit: unit))
    }

    func formatPressure(_ value: Double, unit: UnitPressure = .hectopascals) -> String {
        return formatter.string(from: Measurement<UnitPressure>(value: value, unit: unit))
    }

    func formatSpeed(_ value: Double, unit: UnitSpeed = .metersPerSecond) -> String {
        return formatter.string(from: Measurement<UnitSpeed>(value: value, unit: unit))
    }

    func formatLength(_ value: Double, unit: UnitLength = .meters) -> String {
        return formatter.string(from: Measurement<UnitLength>(value: value, unit: unit))
    }
}

private extension NSMenu {
    func addString(_ string: String) {
        let menuItem = NSMenuItem(title: string, action: nil, keyEquivalent: "")
        menuItem.isEnabled = false
        addItem(menuItem)
    }
}
