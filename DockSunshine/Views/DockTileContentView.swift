//
//  Created by Werner on 23.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import Cocoa
import SunMoonCalc

class DockTileContentView: NSView {
    @IBOutlet var backgroundImageView: NSImageView!
    @IBOutlet var middleImageView: NSImageView!
    @IBOutlet var foregroundImageView: NSImageView!
    @IBOutlet var temperatureLabel: NSTextField!
    @IBOutlet var nameLabel: NSTextField!

    override func awakeFromNib() {
        super.awakeFromNib()

        temperatureLabel.fontDesign(.rounded)

        nameLabel.fontDesign(.rounded)
        nameLabel.textColor = NSColor(white: 1, alpha: 0.75)
    }

    var weatherData: WeatherData? {
        didSet {
            if let weatherData = weatherData,
               let location = weatherData.location,
               let date = weatherData.date,
               location.coordinate != oldValue?.location?.coordinate || date != oldValue?.date {
                print()
                NSLog("\(weatherData)")

                updateSunAndMoon()
                printSunAndMoon()
            }

            updateViews()
        }
    }

    private var sun: Sun?
    private var moon: Moon?

    private func updateSunAndMoon() {
        guard let date = weatherData?.date, let coords = weatherData?.location?.coordinate else { return }
        sun = Sun(location: .init(latitude: coords.latitude, longitude: coords.longitude), date: date)
        moon = Moon(location: .init(latitude: coords.latitude, longitude: coords.longitude), date: date, twilightMode: .closest)
    }

    private func printSunAndMoon() {
        guard let sun = sun, let moon = moon else { return }

        func degrees(_ angle: Measurement<UnitAngle>) -> String {
            return MeasurementFormatter().string(from: angle.converted(to: .degrees))
        }
        func double(_ value: Double) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            return formatter.string(from: NSNumber(value: value))!
        }
        func direction(_ angle: Measurement<UnitAngle>) -> SkyDirection {
            return SkyDirection(angle: angle)
        }

        func date(_ date: Date?) -> String {
            guard let date = date else { return "-" }
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter.string(for: date)!
        }

        print()
        NSLog("Sonnenaufgang: \(date(sun.ephemeris.rise)), -untergang: \(date(sun.ephemeris.set))")
        NSLog("Sonnenrichtung: \(direction(sun.ephemeris.azimuth)) (\(degrees(sun.ephemeris.azimuth)))")
        NSLog("Sonnenstand: \(degrees(sun.ephemeris.elevation)), maximal: \(degrees(sun.ephemeris.transitElevation))")

        print()
        NSLog("Mondaufgang: \(date(moon.ephemeris.rise)), -untergang: \(date(moon.ephemeris.set))")
        NSLog("Mondrichtung:  \(direction(moon.ephemeris.azimuth)) (\(degrees(moon.ephemeris.azimuth)))")
        NSLog("Mondstand: \(degrees(moon.ephemeris.elevation)), maximal: \(degrees(moon.ephemeris.transitElevation))")
        NSLog("Mondphase: \(moon.phase) (\(double(moon.phaseAge / Moon.maxPhaseAge * 100))%%), Beleuchtung: \(double(moon.illumination * 100))%%, Schattenwinkel: \(degrees(moon.diskOrientationViewingAngles.shadow))")
    }

    private func updateViews() {
        backgroundImageView.image = NSImage(named: backgroundImageName)

        if let middleImageName = middleImageName {
            middleImageView.image = NSImage(named: middleImageName)
            middleImageView.frame.origin = middleImagePosition
        } else {
            middleImageView.image = nil
        }

        if let foregroundImageName = foregroundImageName {
            foregroundImageView.image = NSImage(named: foregroundImageName)
        } else {
            foregroundImageView.image = nil
        }

        if let temperature = weatherData?.temperature?.rounded() {
            temperatureLabel.stringValue = "\(Int(temperature))º"
            temperatureLabel.shadow(color: textShadowColor, radius: 5, x: 0, y: 1)

            temperatureLabel.frame.origin.x = 10 + (temperature < 0 ? -1 : 3)
        } else {
            temperatureLabel.stringValue = ""
        }

        nameLabel.stringValue = weatherData?.location?.name ?? ""
    }

    private var daytime: Daytime? {
        guard let date = weatherData?.date, let ephemeris = sun?.ephemeris else { return nil }
        guard let rise = ephemeris.rise, let set = ephemeris.set else { assertionFailure(); return nil }

        return (rise ... set).contains(date) ? .day : .night
    }

    enum Daytime {
        case day
        case night
    }

    private var textShadowColor: NSColor {
        switch true {
        case daytime == .night:
            return NSColor(hex: 0x001F3A).withAlphaComponent(0.86)
        default:
            return NSColor(hex: 0x7E9FB1)
        }
    }

    var foregroundImageName: String? {
        switch weatherData?.condition {
        case .clearSky, .none:
            return nil
        case .fewClouds where daytime == .night:
            return "FewClouds Night Foreground"
        case .fewClouds:
            return "FewClouds Foreground"
        case .scatteredClouds where daytime == .night:
            return "ScatteredClouds Night Foreground"
        case .scatteredClouds:
            return "ScatteredClouds Foreground"
        case .brokenClouds where daytime == .night:
            return "BrokenClouds Night Foreground"
        case .brokenClouds:
            return "BrokenClouds Foreground"
        case .showerRain where daytime == .night:
            return "ShowerRain Night Foreground"
        case .showerRain:
            return "ShowerRain Foreground"
        case .rain where daytime == .night:
            return "Rain Night Foreground"
        case .rain:
            return "Rain Foreground"
        case .thunderstorm where daytime == .night:
            return "Thunderstorm Night Foreground"
        case .thunderstorm:
            return "Thunderstorm Foreground"
        case .snow:
            return "Snow Foreground"
        case .mist:
            return "Mist Foreground"
        }
    }

    private var middleImageName: String? {
        switch daytime {
        case .none:
            return nil
        case .day:
            switch weatherData?.condition {
            case .clearSky, .fewClouds:
                return "Sun"
            case .rain, .mist:
                return "Sun weak"
            default:
                return nil
            }
        case .night:
            switch weatherData?.condition {
            case .clearSky, .fewClouds, .rain:
                return "Moon"
            case .mist:
                return "Moon weak"
            default:
                return nil
            }
        }
    }

    private var middleImagePosition: CGPoint {
        switch weatherData?.condition {
        case .rain:
            return .init(x: 29, y: 70)
        default:
            return .init(x: 5, y: 70)
        }
    }

    private var backgroundImageName: String {
        switch daytime {
        case .day, .none:
            switch weatherData?.condition {
            case .clearSky, .fewClouds, .none:
                return "Clear Background"
            case .scatteredClouds, .brokenClouds, .showerRain, .rain:
                return "Cloudy Background"
            case .thunderstorm:
                return "Thunderstorm Background"
            case .snow:
                return "Snow Background"
            case .mist:
                return "Foggy Background"
            }
        case .night:
            switch weatherData?.condition {
            case .clearSky, .fewClouds, .none:
                return "Clear Night Background"
            case .scatteredClouds, .brokenClouds, .showerRain, .rain:
                return "Cloudy Night Background"
            case .thunderstorm:
                return "Thunderstorm Night Background"
            case .snow:
                return "Snow Night Background"
            case .mist:
                return "Foggy Night Background"
            }
        }
    }
}
