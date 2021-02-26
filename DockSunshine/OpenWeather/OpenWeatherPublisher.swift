//
//  Created by Werner Freytag on 22.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import AppKit
import Combine
import CoreLocation

class OpenWeatherPublisher {
    // Refresh every 10 minutes - or every 10 seconds, when no initial data exists
    var refreshInterval: TimeInterval { didReceiveWeatherData ? TimeInterval(600) : TimeInterval(10) }

    // Update when distance to last position is more than
    let refreshDistance = CLLocationDistance(1000)

    private let weatherDataSubject = PassthroughSubject<WeatherData, Never>()

    private lazy var locationPublisher = LocationPublisher()

    private var cancellable = Set<AnyCancellable>()

    private var refreshTimer: Timer?

    func startUpdating() -> AnyPublisher<WeatherData, Never> {
        currentLocation = UserDefaults.standard.lastLocation

        locationPublisher
            .startUpdating()
            .sink(receiveCompletion: {
                if case let .failure(error) = $0, self.currentLocation == nil {
                    self.handleLocationAuthorizationError(error)
                }
            }, receiveValue: { locations in
                self.currentLocation = locations.last
                UserDefaults.standard.lastLocation = self.currentLocation
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
        refreshTimer = nil
    }

    private func startRefreshTimer() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: refreshInterval, repeats: false, block: { _ in
            self.refresh()
        })
    }

    private var lastUpdateLocation: CLLocation?
    private var currentLocation: CLLocation? {
        didSet {
            guard let currentLocation = currentLocation else { return }
            if let lastUpdateLocation = lastUpdateLocation, refreshDistance > lastUpdateLocation.distance(from: currentLocation) { return }

            refresh()
        }
    }

    private var didReceiveWeatherData = false

    func refresh() {
        stopRefreshTimer()
        defer { startRefreshTimer() }

        guard let requestURL = requestURL else { return }

        URLSession.shared.dataTaskPublisher(for: requestURL)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {
                if case let .failure(error) = $0, !self.didReceiveWeatherData {
                    self.handleDownloadError(error.localizedDescription)
                }
            }, receiveValue: { data, response in
                do {
                    let response = try JSONDecoder().decode(OpenWeatherResponse.self, from: data)
                    guard let weatherData = WeatherData(response: response) else { return assertionFailure() }
                    self.didReceiveWeatherData = true
                    self.weatherDataSubject.send(weatherData)
                } catch {
                    assertionFailure("\(error)")
                }
            })
            .store(in: &cancellable)
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
        guard let currentLocation = currentLocation else { return nil }

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
        alert.messageText = NSLocalizedString("Location services are not enabled.", comment: "Alert title")
        alert.addButton(withTitle: NSLocalizedString("Quit DockSunshine", comment: "Alert button"))
        alert.addButton(withTitle: NSLocalizedString("Open Preferences", comment: "Alert button"))

        let workspace = NSWorkspace.shared
        switch alert.runModal() {
        case .alertFirstButtonReturn:
            NSApp.terminate(self)
        default:
            workspace.open(URL(fileURLWithPath: "x-apple.systempreferences:com.apple.preference.security"))
            workspace.open(URL(fileURLWithPath: "x-apple.systempreferences:com.apple.preference.security?Privacy_LocationServices"))
        }
    }

    private var didShowAlertNoWeatherData = false
    private func handleDownloadError(_ informativeText: String? = nil) {
        guard !didShowAlertNoWeatherData else { return }
        didShowAlertNoWeatherData = true

        let alert = NSAlert()
        alert.messageText = NSLocalizedString("Weather data download failed.", comment: "Alert title")
        if let informativeText = informativeText {
            alert.informativeText = informativeText
        }
        alert.runModal()
    }
}

private extension OpenWeatherResponse.Icon {
    var condition: WeatherData.Condition {
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

    var daytime: WeatherData.Daytime {
        switch self {
        case .clearSky_Night, .fewClouds_Night, .scatteredClouds_Night, .brokenClouds_Night, .showerRain_Night, .rain_Night, .thunderstorm_Night, .snow_Night, .mist_Night:
            return .night
        default:
            return .day
        }
    }
}

private extension WeatherData {
    convenience init?(response: OpenWeatherResponse) {
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
