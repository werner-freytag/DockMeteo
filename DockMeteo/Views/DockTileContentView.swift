//
//  Created by Werner on 23.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import Cocoa
import CoreLocation

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
            updateViews()
        }
    }

    var placemark: CLPlacemark? {
        didSet {
            updateViews()
        }
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

        if var temperature = weatherData?.temperature {
            if UnitTemperature.default ?? .celsius != .celsius {
                temperature = Measurement<UnitTemperature>(value: temperature, unit: .celsius).converted(to: UnitTemperature.default ?? .celsius).value
            }

            let temperatureValue = Int(temperature.rounded())
            temperatureLabel.stringValue = "\(temperatureValue)º"
            temperatureLabel.frame.origin.x = 10 + (temperatureValue < 0 ? -1 : 3)
            temperatureLabel.shadow(color: textShadowColor, radius: 3, x: 0, y: -1.5)
        } else {
            temperatureLabel.stringValue = ""
        }

        if let name = placemark?.locality ?? placemark?.name ?? weatherData?.location.name {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.maximumLineHeight = 13.0
            paragraphStyle.alignment = .center
            nameLabel.attributedStringValue = NSAttributedString(string: name, attributes: [.paragraphStyle: paragraphStyle])
            nameLabel.shadow(color: textShadowColor, radius: 2, x: 0, y: -1.5)
        } else {
            nameLabel.stringValue = ""
        }
    }

    private var textShadowColor: NSColor {
        switch true {
        case weatherData?.isNight:
            return NSColor(hex: 0x001F3A).withAlphaComponent(0.5)
        default:
            return NSColor(hex: 0x7E9FB1).withAlphaComponent(0.5)
        }
    }

    var foregroundImageName: String? {
        guard let weatherData = weatherData else { return nil }
        let isNight = weatherData.isNight

        switch weatherData.condition {
        case .clearSky:
            return nil
        case .fewClouds where isNight:
            return "FewClouds Night Foreground"
        case .fewClouds:
            return "FewClouds Foreground"
        case .scatteredClouds where isNight:
            return "ScatteredClouds Night Foreground"
        case .scatteredClouds:
            return "ScatteredClouds Foreground"
        case .brokenClouds where isNight:
            return "BrokenClouds Night Foreground"
        case .brokenClouds:
            return "BrokenClouds Foreground"
        case .showerRain where isNight:
            return "ShowerRain Night Foreground"
        case .showerRain:
            return "ShowerRain Foreground"
        case .rain where isNight:
            return "Rain Night Foreground"
        case .rain:
            return "Rain Foreground"
        case .thunderstorm where isNight:
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
        switch weatherData?.isNight {
        case true:
            switch weatherData?.condition {
            case .clearSky, .fewClouds, .rain:
                return "Moon"
            case .mist:
                return "Moon Weak"
            default:
                return nil
            }
        default:
            switch weatherData?.condition {
            case .clearSky, .fewClouds:
                return "Sun"
            case .rain, .mist:
                return "Sun Weak"
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
        switch weatherData?.isNight {
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
