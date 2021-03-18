//
//  Created by Werner on 15.03.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import Foundation
import SunMoonCalc

extension OpenWeatherResponse: CustomStringConvertible {
    var description: String {
        "\(weather.first!.description), \(formatDouble(main.temp))º (feels like \(formatDouble(main.feels_like))º), pressure: \(main.pressure) hPa, humidity: \(main.humidity)%%, visibility: \(formatDouble(Double(visibility), maximumFractionDigits: 0)) m, wind: \(formatDouble(wind.speed)) m/s from \(SkyDirection(degrees: Double(wind.deg))), clouds: \(clouds.all)%%, date: \(formatDate(Date(timeIntervalSince1970: dt))), location: \(name), \(sys.country) (\(coord.lat), \(coord.lon))"
    }
}

extension WeatherData: CustomStringConvertible {
    var description: String { "\(condition), \(formatDouble(temperature))º, \(location), \(formatDate(date))" }
}

extension WeatherData.Condition: CustomStringConvertible {
    var description: String {
        switch self {
        case .clearSky: return "clear sky"
        case .fewClouds: return "few clouds"
        case .scatteredClouds: return "scattered clouds"
        case .brokenClouds: return "broken clouds"
        case .showerRain: return "shower rain"
        case .rain: return "rain"
        case .thunderstorm: return "thunderstorm"
        case .snow: return "snow"
        case .mist: return "mist"
        }
    }
}

extension WeatherData.Location: CustomStringConvertible {
    var description: String {
        "\(name) @ \(coordinate)"
    }
}

extension WeatherData.Location.Coordinate: CustomStringConvertible {
    var description: String { "<\(latitude),\(longitude)>" }
}

extension Sun: CustomStringConvertible {
    public var description: String {
        "\(ephemeris)"
    }
}

extension Moon: CustomStringConvertible {
    public var description: String {
        "\(ephemeris), phase: \(phase) (\(formatDouble(((phaseAge < Moon.maxPhaseAge / 2) ? phaseAge * 2 : phaseAge * 2 - Moon.maxPhaseAge) / Moon.maxPhaseAge * 100))%%/\((phaseAge < Moon.maxPhaseAge / 2) ? "+" : "-")), illumination: \(formatDouble(illumination * 100))%%, shadow angle: \(formatDegrees(diskOrientationViewingAngles.shadow.converted(to: .degrees).value))"
    }
}

extension Moon.Phase: CustomStringConvertible {
    public var description: String {
        switch self {
        case .newMoon: return "new moon"
        case .waxingCrescent: return "waxing crescent"
        case .firstQuarter: return "first quarter"
        case .waxingGibbous: return "waxing gibbous"
        case .fullMoon: return "fullMoon"
        case .waningGibbous: return "waning gibbous"
        case .lastQuarter: return "last quarter"
        case .waningCrescent: return "waning crescent"
        }
    }
}

extension Ephemeris: CustomStringConvertible {
    public var description: String {
        "azimuth: \(formatDirection(azimuth.converted(to: .degrees).value)), elevation: \(formatDegrees(elevation.converted(to: .degrees).value)), rise: \(formatDate(rise)), set: \(formatDate(set)), transit: \(formatDate(transit)), transit elevation: \(formatDegrees(transitElevation.converted(to: .degrees).value)), distance: \(formatDouble(distance.converted(to: .kilometers).value)) km"
    }
}

private func formatDegrees(_ degrees: Double) -> String {
    return MeasurementFormatter().string(from: Measurement<UnitAngle>(value: degrees, unit: .degrees))
}

private func formatDouble(_ value: Double, maximumFractionDigits: Int = 2) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = maximumFractionDigits
    return formatter.string(from: NSNumber(value: value))!
}

private func formatDirection(_ degrees: Double) -> String {
    "\(formatDegrees(degrees)) (\(SkyDirection(degrees: degrees)))"
}

private func formatDate(_ date: Date?) -> String {
    guard let date = date else { return "-" }
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .long
    return formatter.string(for: date)!
}

extension SkyDirection: CustomStringConvertible {
    private static let north = NSLocalizedString("N", comment: "Short for sky direction North")
    private static let east = NSLocalizedString("E", comment: "Short for sky direction East")
    private static let south = NSLocalizedString("S", comment: "Short for sky direction South")
    private static let west = NSLocalizedString("W", comment: "Short for sky direction West")

    var description: String {
        switch self {
        case .N:
            return Self.north
        case .NNE:
            return Self.north + Self.north + Self.east
        case .NE:
            return Self.north + Self.east
        case .ENE:
            return Self.east + Self.north + Self.east
        case .E:
            return Self.east
        case .ESE:
            return Self.east + Self.south + Self.east
        case .SE:
            return Self.south + Self.east
        case .SSE:
            return Self.south + Self.south + Self.east
        case .S:
            return Self.south
        case .SSW:
            return Self.south + Self.south + Self.west
        case .SW:
            return Self.south + Self.west
        case .WSW:
            return Self.west + Self.south + Self.west
        case .W:
            return Self.west
        case .WNW:
            return Self.west + Self.north + Self.west
        case .NW:
            return Self.north + Self.west
        case .NNW:
            return Self.north + Self.north + Self.west
        }
    }
}
