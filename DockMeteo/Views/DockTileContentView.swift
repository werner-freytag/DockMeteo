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
        temperatureLabel.wantsLayer = true

        nameLabel.fontDesign(.rounded)
        nameLabel.textColor = NSColor(white: 1, alpha: 0.75)
        nameLabel.wantsLayer = true
    }

    var weatherData: WeatherData? {
        didSet {
            updateSunAndMoon()

            NSLog("Sun: \(sun!)\n")
            NSLog("Moon: \(moon!)\n")

            updateViews()
        }
    }

    var placemark: CLPlacemark? {
        didSet {
            updateViews()
        }
    }

    private var sun: Sun?
    private var moon: Moon?

    private func updateSunAndMoon() {
        guard let date = weatherData?.date, let coords = weatherData?.location.coordinate else { return }
        sun = Sun(location: .init(latitude: coords.latitude, longitude: coords.longitude), date: date)
        moon = Moon(location: .init(latitude: coords.latitude, longitude: coords.longitude), date: date, twilightMode: .closest)
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

        if let temperature = weatherData?.temperature.rounded() {
            temperatureLabel.stringValue = "\(Int(temperature))º"
            temperatureLabel.frame.origin.x = 10 + (temperature < 0 ? -1 : 3)
            temperatureLabel.shadow(color: textShadowColor, radius: 3, x: 0, y: -1.5)
        } else {
            temperatureLabel.stringValue = ""
        }

        if let name = placemark?.locality ?? weatherData?.location.name {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.maximumLineHeight = 13.0
            paragraphStyle.alignment = .center
            nameLabel.attributedStringValue = NSAttributedString(string: name, attributes: [.paragraphStyle: paragraphStyle])
            nameLabel.shadow(color: textShadowColor, radius: 3, x: 0, y: -2)
        } else {
            nameLabel.stringValue = ""
        }
    }

    private var isNight: Bool? {
        guard let date = weatherData?.date, let ephemeris = sun?.ephemeris else { return nil }
        guard let rise = ephemeris.rise, let set = ephemeris.set else { assertionFailure(); return nil }

        guard rise <= set else { return (set ... rise).contains(date) }

        return !(rise ... set).contains(date)
    }

    private var textShadowColor: NSColor {
        switch true {
        case isNight:
            return NSColor(hex: 0x001F3A).withAlphaComponent(0.5)
        default:
            return NSColor(hex: 0x7E9FB1).withAlphaComponent(0.5)
        }
    }

    var foregroundImageName: String? {
        switch weatherData?.condition {
        case .clearSky, .none:
            return nil
        case .fewClouds where isNight == true:
            return "FewClouds Night Foreground"
        case .fewClouds:
            return "FewClouds Foreground"
        case .scatteredClouds where isNight == true:
            return "ScatteredClouds Night Foreground"
        case .scatteredClouds:
            return "ScatteredClouds Foreground"
        case .brokenClouds where isNight == true:
            return "BrokenClouds Night Foreground"
        case .brokenClouds:
            return "BrokenClouds Foreground"
        case .showerRain where isNight == true:
            return "ShowerRain Night Foreground"
        case .showerRain:
            return "ShowerRain Foreground"
        case .rain where isNight == true:
            return "Rain Night Foreground"
        case .rain:
            return "Rain Foreground"
        case .thunderstorm where isNight == true:
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
        switch isNight {
        case true:
            switch weatherData?.condition {
            case .clearSky, .fewClouds, .rain:
                return "Moon"
            case .mist:
                return "Moon weak"
            default:
                return nil
            }
        default:
            switch weatherData?.condition {
            case .clearSky, .fewClouds:
                return "Sun"
            case .rain, .mist:
                return "Sun weak"
            default:
                return nil
            }
        }
    }

    private var middleImagePosition: CGPoint {
        switch weatherData?.condition {
        case .rain:
            return .init(x: 33, y: 83)
        default:
            return .init(x: 5, y: 70)
        }
    }

    private var backgroundImageName: String {
        switch isNight {
        case true:
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
        default:
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
        }
    }
}
