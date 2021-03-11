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

            if let foregroundImageName = foregroundImageName {
                foregroundImageView.image = NSImage(named: foregroundImageName)
            } else {
                foregroundImageView.image = nil
            }

            if let temperature = weatherData?.temperature?.rounded() {
                temperatureLabel.stringValue = "\(Int(temperature))º"
                temperatureLabel.shadow(color: textShadowColor, radius: 5, x: 0, y: 1)

                temperatureLabel.frame.origin.x = 10 + (temperature < 0 ? -2 : 6)
            } else {
                temperatureLabel.stringValue = ""
            }

            nameLabel.stringValue = weatherData?.name ?? ""
        }
    }
}

/*
     @ObservedObject var weatherData: WeatherData

     var body: some View {
         ZStack {
             Image(backgroundImageName)
             if let foregroundImageName = foregroundImageName {
                 Image(foregroundImageName)
             }

             if false {
                 SunView()
                     .frame(width: SunView.originalSize.width, height: SunView.originalSize.height)
                     .transformEffect(.init(translationX: 33, y: 33))
                     .shadow(color: textShadowColor, radius: 3, x: 0, y: 0)
                 ZStack {
     //                MoonView(fill: .init(hex: 0x526288), spotFill: .init(white: 0).opacity(0.1))
                     MoonView()
                         .applyingSphericShadowMask(yAngle: .degrees(60), zAngle: .zero)
                 }
                 .frame(width: 26, height: 26)
                 .transformEffect(.init(translationX: 33, y: -33))
                 .shadow(color: textShadowColor, radius: 3, x: 0, y: 0)
             }

             SnowFlakeShape()
                 .stroke(Color.white, style: StrokeStyle(lineWidth: 1.5, lineCap: .round))
                 .frame(width: SnowFlakeShape.originalSize.width, height: SnowFlakeShape.originalSize.height)
                 .transformEffect(.init(translationX: -33, y: -33))
                 .shadow(color: textShadowColor, radius: 3, x: 0, y: 0)
             RainShape()
                 .stroke(Color(red: 0.3, green: 0.4, blue: 0.5).opacity(0.7), style: StrokeStyle(lineWidth: 1.0, lineCap: .round))
                 .frame(width: RainShape.originalSize.width, height: RainShape.originalSize.height)
                 .transformEffect(.init(translationX: 0, y: -33))
                 .shadow(color: textShadowColor, radius: 3, x: 0, y: 0)
             FlashShape()
                 .fill(Color.white)
                 .frame(width: FlashShape.originalSize.width, height: FlashShape.originalSize.height)
                 .transformEffect(.init(translationX: -33, y: 0))
             CloudShape()
                 .fill(Color.white)
                 .frame(width: CloudShape.originalSize.width, height: CloudShape.originalSize.height)
                 .transformEffect(.init(translationX: -33, y: 33))
                 .shadow(color: textShadowColor, radius: 3, x: 0, y: 0)
             if let temperature = weatherData.temperature?.rounded() {
                 TemperatureView(temperature: Int(temperature), textShadowColor: textShadowColor)
             }
             if let name = weatherData.name {
                 NameView(name: name)
             }
         }
         .frame(width: 128.0, height: 128.0)
     }

     private func applyDaytime(to string: String) -> String {
         weatherData.daytime == .night ? "\(string)_Night" : string
     }

     private var textShadowColor: Color {
         switch true {
         case weatherData.daytime == .night:
             return Color(hex: 0x001F3A).opacity(0.86)
         default:
             return Color(hex: 0x7E9FB1)
         }
     }

     private var backgroundGradient: Gradient {
         switch true {
         default:
             return Gradient(colors: [.init(hex: 0xABD8FF), .init(hex: 0x4CA7E3).opacity(0.9)])
         }
     }

     private var image: String {
         switch weatherData.condition {
         case .clearSky:
             return applyDaytime(to: "Clear")
         case .fewClouds:
             return applyDaytime(to: "FewClouds")
         case .scatteredClouds:
             return applyDaytime(to: "ScatteredClouds")
         case .brokenClouds:
             return applyDaytime(to: "BrokenClouds")
         case .showerRain:
             return applyDaytime(to: "ShowerRain")
         case .rain:
             return applyDaytime(to: "Rain")
         case .thunderstorm:
             return applyDaytime(to: "Thunderstorm")
         case .snow:
             return applyDaytime(to: "Snow")
         case .mist:
             return applyDaytime(to: "Mist")
         case .none:
             return "Placeholder"
         }
     }
 }

 struct DockTileContentView_Previews: PreviewProvider {
     static var previews: some View {
         Group {
             DockTileContentView(weatherData: WeatherData(condition: .clearSky, name: "Paris", temperature: 32))
             DockTileContentView(weatherData: WeatherData(condition: .fewClouds, daytime: .night, name: "San Francisco", temperature: 47))
             DockTileContentView(weatherData: WeatherData(condition: .snow, name: "St. Moritz", temperature: -1))
             DockTileContentView(weatherData: WeatherData(condition: .rain, name: "London", temperature: 19))
         }
     }
 }

 struct NameView: View {
     var name: String
     var body: some View {
         VStack {
             Spacer()
             Text(name)
                 .font(.system(size: 14, weight: .regular, design: .rounded))
                 .multilineTextAlignment(.center)
                 .lineLimit(2)
                 .frame(width: 94.0, height: 35.0)
                 .foregroundColor(Color.white)
                 .opacity(0.75)
             Spacer()
                 .frame(height: 17.0)
         }
     }
 }

 struct TemperatureView: View {
     var temperature: Int
     var textShadowColor: Color

     var body: some View {
         VStack {
             HStack {
                 Spacer()
                     .frame(width: 6.0)
                 Text("\(temperature)º")
                     .font(.system(size: 38, weight: .light, design: .rounded))
                     .multilineTextAlignment(.center)
                     .foregroundColor(Color.white)
                     .shadow(color: textShadowColor, radius: 5, x: 0, y: 1)
                 if temperature < 0 {
                     Spacer()
                         .frame(width: 16)
                 }
             }
             Spacer()
                 .frame(height: 6.0)
         }
     }
 }

 //var conditionDetails: (backgroundImage: String, foregroundImage: String?, sunImage: String?, moonImage: String?) {

 private extension DockTileContentView {

 }
 */

private extension DockTileContentView {
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

    var backgroundImageName: String {
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
