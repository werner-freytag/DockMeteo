//
//  Created by Werner on 23.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import Cocoa

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

            nameLabel.stringValue = weatherData?.name ?? ""
        }
    }

    private var textShadowColor: NSColor {
        switch true {
        case weatherData?.daytime == .night:
            return NSColor(hex: 0x001F3A).withAlphaComponent(0.86)
        default:
            return NSColor(hex: 0x7E9FB1)
        }
    }

    var foregroundImageName: String? {
        switch weatherData?.condition {
        case .clearSky, .none:
            return nil
        case .fewClouds where weatherData?.daytime == .night:
            return "FewClouds Night Foreground"
        case .fewClouds:
            return "FewClouds Foreground"
        case .scatteredClouds where weatherData?.daytime == .night:
            return "ScatteredClouds Night Foreground"
        case .scatteredClouds:
            return "ScatteredClouds Foreground"
        case .brokenClouds where weatherData?.daytime == .night:
            return "BrokenClouds Night Foreground"
        case .brokenClouds:
            return "BrokenClouds Foreground"
        case .showerRain where weatherData?.daytime == .night:
            return "ShowerRain Night Foreground"
        case .showerRain:
            return "ShowerRain Foreground"
        case .rain where weatherData?.daytime == .night:
            return "Rain Night Foreground"
        case .rain:
            return "Rain Foreground"
        case .thunderstorm where weatherData?.daytime == .night:
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
        switch weatherData?.daytime {
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
        switch weatherData?.daytime {
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
