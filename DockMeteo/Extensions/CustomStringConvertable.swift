//
//  Created by Werner on 15.03.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import Foundation
import SunMoonCalc

extension WeatherData: CustomStringConvertible {
    var description: String { "\(condition), \(formatDouble(temperature))º, \(location)" }
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
        "\(ephemeris), phase: \(phase) (\(formatDouble(((phaseAge < Moon.maxPhaseAge / 2) ? phaseAge * 2 : phaseAge * 2 - Moon.maxPhaseAge) / Moon.maxPhaseAge * 100))%%/\((phaseAge < Moon.maxPhaseAge / 2) ? "+" : "-")), illumination: \(formatDouble(illumination * 100))%%, shadow angle: \(formatDegrees(diskOrientationViewingAngles.shadow))"
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
        "azimuth: \(formatDirection(azimuth)), elevation: \(formatDegrees(elevation)), rise: \(formatDate(rise)), set: \(formatDate(set)), transit: \(formatDate(transit)), transit elevation: \(formatDegrees(transitElevation)), distance: \(formatDouble(distance.converted(to: .kilometers).value)) km"
    }
}

private func formatDegrees(_ angle: Measurement<UnitAngle>) -> String {
    return MeasurementFormatter().string(from: angle.converted(to: .degrees))
}

private func formatDouble(_ value: Double, maximumFractionDigits: Int = 2) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = maximumFractionDigits
    return formatter.string(from: NSNumber(value: value))!
}

private func formatDirection(_ angle: Measurement<UnitAngle>) -> String {
    "\(formatDegrees(angle)) (\(SkyDirection(angle: angle)))"
}

private func formatDate(_ date: Date?) -> String {
    guard let date = date else { return "-" }
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter.string(for: date)!
}
