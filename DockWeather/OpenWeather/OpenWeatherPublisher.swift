//
//  Created by Werner Freytag on 22.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import AppKit
import Combine
import CoreLocation

class OpenWeatherPublisher {
    // Refresh every 10 minutes
    let refreshInterval = TimeInterval(600)

    // Update when distance to last position is more than
    let refreshDistance = CLLocationDistance(1000)

    private let weatherDataSubject = PassthroughSubject<WeatherData, Never>()

    private lazy var locationPublisher = LocationPublisher()

    private var cancellable = Set<AnyCancellable>()

    private var refreshTimer: Timer?

    func startUpdating() -> AnyPublisher<WeatherData, Never> {
        locationPublisher
            .startUpdating()
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.handleLocationAuthorizationError(error)
                }
            }, receiveValue: { locations in
                self.currentLocation = locations.last
            })
            .store(in: &cancellable)

        NotificationCenter.default.publisher(for: NSLocale.currentLocaleDidChangeNotification)
            .sink { _ in
                self.refresh()
            }
            .store(in: &cancellable)

        startRefreshTimer()

        return weatherDataSubject.eraseToAnyPublisher()
    }

    private func stopRefreshTimer() {
        refreshTimer?.invalidate()
    }

    private func startRefreshTimer() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: refreshInterval, repeats: false, block: { _ in
            self.refresh()
        })
    }

    private var lastUpdateLocation: CLLocation?
    private var currentLocation: CLLocation? {
        didSet {
            guard let currentLocation = currentLocation else { return assertionFailure() }
            if let lastUpdateLocation = lastUpdateLocation, refreshDistance > lastUpdateLocation.distance(from: currentLocation) { return }

            refresh()
        }
    }

    func refresh() {
        stopRefreshTimer()
        defer { startRefreshTimer() }

        guard let requestURL = requestURL else { return }

        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            guard let data = data else { assertionFailure(); return }

            do {
                let response = try JSONDecoder().decode(OpenWeatherResponse.self, from: data)
                guard let weatherData = WeatherData(response: response) else { return assertionFailure() }
                self.weatherDataSubject.send(weatherData)
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

    private func handleLocationAuthorizationError(_ error: LocationPublisher.Error) {
        let alert = NSAlert()
        alert.messageText = "Location services are not enabled."
        alert.addButton(withTitle: "Quit DockWeather")
        alert.addButton(withTitle: "Open Preferences")

        let workspace = NSWorkspace.shared
        switch alert.runModal() {
        case .alertFirstButtonReturn:
            NSApp.terminate(self)
        default:
            workspace.open(URL(fileURLWithPath: "x-apple.systempreferences:com.apple.preference.security"))
            workspace.open(URL(fileURLWithPath: "x-apple.systempreferences:com.apple.preference.security?Privacy_LocationServices"))
        }
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

private extension WeatherData {
    init?(response: OpenWeatherResponse) {
        assert(response.weather.last != nil)
        guard let weather = response.weather.last else { return nil }

        self.init(
            condition: weather.icon.condition,
            daytime: weather.icon.daytime,
            name: response.name,
            datetime: Date(timeIntervalSince1970: response.dt),
            datetimeRange: Date(timeIntervalSince1970: response.sys.sunrise) ..< Date(timeIntervalSince1970: response.sys.sunset),
            temperature: response.main.temp,
            temperatureRange: response.main.temp_min ..< response.main.temp_max
        )
    }
}
