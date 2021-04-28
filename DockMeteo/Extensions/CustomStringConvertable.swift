//
//  Created by Werner on 15.03.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import Foundation

extension OpenWeatherResponse: CustomStringConvertible {
    var description: String {
        "\(weather.first!.id), \(formatDouble(main.temp))º (feels like \(formatDouble(main.feels_like))º), pressure: \(main.pressure) hPa, humidity: \(main.humidity)%%, visibility: \(formatDouble(Double(visibility), maximumFractionDigits: 0)) m, wind: \(formatDouble(wind.speed)) m/s from \(SkyDirection(degrees: Double(wind.deg))), clouds: \(clouds.all)%%, date: \(formatDate(Date(timeIntervalSince1970: dt))), location: \(name), \(sys.country) (\(coord.lat), \(coord.lon))"
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
    var description: String {
        switch self {
        case .N:
            return NSLocalizedString("SkyDirection.N", comment: "Short for SkyDirection N")
        case .NNE:
            return NSLocalizedString("SkyDirection.NNE", comment: "Short for SkyDirection NNE")
        case .NE:
            return NSLocalizedString("SkyDirection.NE", comment: "Short for SkyDirection NE")
        case .ENE:
            return NSLocalizedString("SkyDirection.ENE", comment: "Short for SkyDirection ENE")
        case .E:
            return NSLocalizedString("SkyDirection.E", comment: "Short for SkyDirection E")
        case .ESE:
            return NSLocalizedString("SkyDirection.ESE", comment: "Short for SkyDirection ESE")
        case .SE:
            return NSLocalizedString("SkyDirection.SE", comment: "Short for SkyDirection SE")
        case .SSE:
            return NSLocalizedString("SkyDirection.SSE", comment: "Short for SkyDirection SSE")
        case .S:
            return NSLocalizedString("SkyDirection.S", comment: "Short for SkyDirection S")
        case .SSW:
            return NSLocalizedString("SkyDirection.SSW", comment: "Short for SkyDirection SSW")
        case .SW:
            return NSLocalizedString("SkyDirection.SW", comment: "Short for SkyDirection SW")
        case .WSW:
            return NSLocalizedString("SkyDirection.WSW", comment: "Short for SkyDirection WSW")
        case .W:
            return NSLocalizedString("SkyDirection.W", comment: "Short for SkyDirection W")
        case .WNW:
            return NSLocalizedString("SkyDirection.WNW", comment: "Short for SkyDirection WNW")
        case .NW:
            return NSLocalizedString("SkyDirection.NW", comment: "Short for SkyDirection NW")
        case .NNW:
            return NSLocalizedString("SkyDirection.NNW", comment: "Short for SkyDirection NNW")
        }
    }
}
