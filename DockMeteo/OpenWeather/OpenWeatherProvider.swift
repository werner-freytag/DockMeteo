//
//  Created by Werner Freytag on 22.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import AppKit
import CoreLocation
import Foundation

@MainActor
class OpenWeatherProvider {
    private static let refreshInterval: TimeInterval = 600
    private static let refreshDistance: CLLocationDistance = 1000

    private(set) var location: CLLocation?
    private var weatherData: WeatherData?
    private var lastUpdateDate: Date?
    private var isRefreshing = false
    private var weatherContinuation: AsyncStream<WeatherData>.Continuation?

    func startUpdating() -> AsyncStream<WeatherData> {
        var continuation: AsyncStream<WeatherData>.Continuation!
        let stream = AsyncStream<WeatherData> { continuation = $0 }
        weatherContinuation = continuation

        Task {
            while true {
                let elapsed = lastUpdateDate.map { -$0.timeIntervalSinceNow } ?? Self.refreshInterval
                if elapsed >= Self.refreshInterval {
                    await refresh()
                }
                try? await Task.sleep(nanoseconds: 10_000_000_000)
            }
        }

        Task {
            for await _ in NotificationCenter.default.notifications(named: NSLocale.currentLocaleDidChangeNotification) {
                await refresh()
            }
        }

        return stream
    }

    func update(location: CLLocation) async {
        let shouldRefresh: Bool
        if let prev = weatherData?.location {
            shouldRefresh = CLLocation(prev).distance(from: location) >= Self.refreshDistance
        } else {
            shouldRefresh = true
        }
        self.location = location
        if shouldRefresh {
            await refresh()
        }
    }

    private func refresh() async {
        guard !isRefreshing, let location, let requestURL = makeRequestURL(for: location) else { return }
        isRefreshing = true
        defer { isRefreshing = false }

        do {
            let (data, _) = try await URLSession.shared.data(from: requestURL)
            let response = try JSONDecoder().decode(OpenWeatherResponse.self, from: data)
            NSLog("Weather: \(response)\n")
            guard let weatherData = WeatherData(response: response) else {
                assertionFailure()
                return
            }
            self.weatherData = weatherData
            self.lastUpdateDate = .now
            weatherContinuation?.yield(weatherData)
        } catch {
            NSLog("Weather data download failed: %@", error.localizedDescription)
        }
    }

    private func makeRequestURL(for location: CLLocation) -> URL? {
        let appId = Bundle.main.object(forInfoDictionaryKey: "OPEN_WEATHER_APP_ID") as? String
        var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")!
        urlComponents.queryItems = [
            URLQueryItem(name: "appid", value: appId),
            URLQueryItem(name: "lat", value: String(format: "%f", location.coordinate.latitude)),
            URLQueryItem(name: "lon", value: String(format: "%f", location.coordinate.longitude)),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: Locale.current.languageCode),
        ]
        return urlComponents.url
    }
}

private extension OpenWeatherResponse.Icon {
    var condition: WeatherData.Condition {
        switch self {
        case .clearSky_Day, .clearSky_Night: return .clearSky
        case .fewClouds_Day, .fewClouds_Night: return .fewClouds
        case .scatteredClouds_Day, .scatteredClouds_Night: return .scatteredClouds
        case .brokenClouds_Day, .brokenClouds_Night: return .brokenClouds
        case .showerRain_Day, .showerRain_Night: return .showerRain
        case .rain_Day, .rain_Night: return .rain
        case .thunderstorm_Day, .thunderstorm_Night: return .thunderstorm
        case .snow_Day, .snow_Night: return .snow
        case .mist_Day, .mist_Night: return .mist
        }
    }

    var isNight: Bool {
        switch self {
        case .clearSky_Night, .fewClouds_Night, .scatteredClouds_Night, .brokenClouds_Night,
             .showerRain_Night, .rain_Night, .thunderstorm_Night, .snow_Night, .mist_Night:
            return true
        default:
            return false
        }
    }
}

private extension WeatherData {
    init?(response: OpenWeatherResponse) {
        assert(response.weather.last != nil)
        guard let weather = response.weather.last else { return nil }
        self.init(
            condition: weather.icon.condition,
            temperature: response.main.temp,
            location: .init(name: response.name, coordinate: .init(latitude: response.coord.lat, longitude: response.coord.lon)),
            date: Date(timeIntervalSince1970: response.dt),
            isNight: weather.icon.isNight,
            details: Details(response: response)
        )
    }
}

private extension WeatherData.Details {
    init?(response: OpenWeatherResponse) {
        self.init(
            conditionDescription: response.weather.last?.description,
            temperatureFelt: response.main.feels_like,
            pressure: response.main.pressure,
            humidity: response.main.humidity,
            visibility: response.visibility,
            wind: .init(speed: response.wind.speed, direction: SkyDirection(degrees: Double(response.wind.deg))),
            clouds: response.clouds.all
        )
    }
}

private extension CLLocation {
    convenience init(_ location: WeatherData.Location) {
        self.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
}
