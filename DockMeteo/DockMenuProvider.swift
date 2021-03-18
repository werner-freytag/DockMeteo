//
//  Created by Werner on 18.03.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import Cocoa

struct DockMenuProvider {
    var placemark: CLPlacemark?
    var weatherData: WeatherData?

    var menu: NSMenu {
        let menu = NSMenu(title: NSLocalizedString("Info", comment: ""))

        menu.addString(NSLocalizedString("Location", comment: "Info menu: Location").localizedUppercase)

        if let placemark = placemark, let formattedAddress = placemark.formattedAddress {
            menu.addString(formattedAddress)
        } else if let place = weatherData?.location.name {
            menu.addString(place)
        } else {
            menu.addString("-")
        }

        menu.addItem(.separator())

        menu.addString(NSLocalizedString("Weather", comment: "Info menu: Weather").localizedUppercase)

        if let weatherData = weatherData {
            let formatter = MeasurementFormatter()

            func formatTemperature(_ degrees: Double) -> String {
                formatter.string(from: Measurement<UnitTemperature>(value: Double(Int(degrees.rounded())), unit: UnitTemperature.default ?? .celsius))
            }

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
                        details.append(String(format: NSLocalizedString("pressure: %@", comment: "Info menu: pressure"), formatter.string(from: Measurement<UnitPressure>(value: Double(pressure), unit: .hectopascals))))
                    }

                    if let humidity = weatherData.details?.humidity {
                        details.append(String(format: NSLocalizedString("humidity: %@", comment: "Info menu: humidity"), "\(humidity) %"))
                    }

                    if let visibility = weatherData.details?.visibility {
                        details.append(String(format: NSLocalizedString("visibility: %@", comment: "Info menu: visibility"), formatter.string(from: Measurement<UnitLength>(value: Double(visibility), unit: .meters))))
                    }

                    return details
                }(),

                {
                    var details: [String] = []

                    if let wind = weatherData.details?.wind {
                        details.append(String(format: NSLocalizedString("wind: %@ from %@", comment: "Info menu: wind <speed> from <direction>"),
                                              formatter.string(from: Measurement<UnitSpeed>(value: Double(wind.speed), unit: .metersPerSecond)),
                                              wind.direction.description))
                    }

                    if let clouds = weatherData.details?.clouds {
                        details.append(String(format: NSLocalizedString("clouds: %@", comment: "Info menu: clouds"), "\(clouds) %"))
                    }

                    return details
                }(),
            ]

            for row in details {
                guard !row.isEmpty else { continue }
                menu.addString(row.joined(separator: ", ").capitalizingFirstLetter)
            }
        } else {
            menu.addString("-")
        }

        return menu
    }
}

private extension NSMenu {
    func addString(_ string: String) {
        let menuItem = NSMenuItem(title: string, action: nil, keyEquivalent: "")
        menuItem.isEnabled = false
        addItem(menuItem)
    }
}
