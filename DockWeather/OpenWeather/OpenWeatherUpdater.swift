//
//  Created by Werner Freytag on 22.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import CoreLocation
import Foundation

class OpenWeatherUpdater {
    // Refresh every 10 minutes
    let refreshInterval = TimeInterval(600)

    // Update when distance to last position is more than
    let refreshDistance = CLLocationDistance(1000)

    private var refreshTimer: Timer?

    func startUpdating() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.Location.didUpdate, object: nil, queue: nil) {
            guard let locations = $0.userInfo?["locations"] as? [CLLocation] else { return assertionFailure() }
            self.currentLocation = locations.last
        }

        NotificationCenter.default.addObserver(forName: NSLocale.currentLocaleDidChangeNotification, object: nil, queue: nil) { _ in
            self.refresh()
        }

        startRefreshTimer()
    }

    private func stopRefreshTimer() {
        refreshTimer?.invalidate()
    }

    private func startRefreshTimer() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: refreshInterval, repeats: false, block: { _ in
            self.refresh()
        })
    }

    private var currentLocation: CLLocation? {
        didSet {
            if let lastUpdateLocation = lastUpdateLocation {
                guard let currentLocation = currentLocation else { return assertionFailure() }

                if lastUpdateLocation.distance(from: currentLocation) > refreshDistance {
                    refresh()
                }
            } else {
                refresh()
            }
        }
    }

    private var lastUpdateLocation: CLLocation?

    func refresh() {
        stopRefreshTimer()
        defer { startRefreshTimer() }

        guard let requestURL = requestURL else { return }

        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            guard let data = data else { assertionFailure(); return }
            do {
                let response = try JSONDecoder().decode(OpenWeatherResponse.self, from: data)
                NotificationCenter.default.post(Notification(name: Notification.Name.WeatherData.didRefresh, object: self, userInfo: ["data": response.weatherData]))
            } catch {
                assertionFailure("\(error)")
            }
        }.resume()
    }

    private var temperatureUnit: TemperatureUnitPreferences {
        do {
            return try TemperatureUnitPreferences()
        } catch {
            assertionFailure("\(error)")
            return .celsius
        }
    }

    private var requestURL: URL? {
        guard let currentLocation = currentLocation else { assertionFailure(); return nil }

        var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")!
        urlComponents.queryItems = [
            URLQueryItem(name: "appid", value: "5d20c08f748c06727dbdacc4d6dd2c42"),
            URLQueryItem(name: "lat", value: String(format: "%f", currentLocation.coordinate.latitude)),
            URLQueryItem(name: "lon", value: String(format: "%f", currentLocation.coordinate.longitude)),
            URLQueryItem(name: "units", value: temperatureUnit == .celsius ? "metric" : "imperial"),
        ]

        return urlComponents.url
    }
}

public extension Notification.Name {
    enum WeatherData {
        public static let didRefresh = Notification.Name(rawValue: "WeatherData.didRefresh")
    }
}

private extension OpenWeatherResponse.Icon {
    var condition: WeatherCondition {
        switch self {
        case .clearSky_Day, .clearSky_Night:
            return .clearSky
        case .fewClouds_Day, .fewClouds_Night:
            return .fewClouds
        case .scatteredClouds_Day, .scatteredClouds_Night:
            return .scatteredClouds
        case .brokenClouds_Day, .brokenClouds_Night:
            return .brokenClouds
        case .showerRain_Day, .showerRain_Night:
            return .showerRain
        case .rain_Day, .rain_Night:
            return .rain
        case .thunderstorm_Day, .thunderstorm_Night:
            return .thunderstorm
        case .snow_Day, .snow_Night:
            return .snow
        case .mist_Day, .mist_Night:
            return .mist
        }
    }

    var daytime: Daytime {
        switch self {
        case .clearSky_Night, .fewClouds_Night, .scatteredClouds_Night, .brokenClouds_Night, .showerRain_Night, .rain_Night, .thunderstorm_Night, .snow_Night, .mist_Night:
            return .night
        default:
            return .day
        }
    }
}

extension OpenWeatherResponse {
    var weatherData: WeatherData {
        assert(weather.last != nil)
        let weather = weather.last ?? Weather(id: 0, main: "", description: "", icon: .clearSky_Day)
        return WeatherData(
            condition: weather.icon.condition,
            daytime: weather.icon.daytime,
            name: name,
            datetime: Date(timeIntervalSince1970: dt),
            datetimeRange: Date(timeIntervalSince1970: sys.sunrise) ..< Date(timeIntervalSince1970: sys.sunset),
            temperature: main.temp,
            temperatureRange: main.temp_min ..< main.temp_max
        )
    }
}
