//
//  Created by Werner Freytag on 22.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import AppKit
import Combine
import CoreLocation
import SunMoonCalc

class OpenWeatherPublisher {
    // Refresh every 10 minutes - or every 10 seconds, when no initial data exists
    var refreshInterval: TimeInterval { weatherData.condition == nil || weatherData.location?.name == nil ? TimeInterval(10) : TimeInterval(600) }

    // Update when distance to last position is more than
    let refreshDistance = CLLocationDistance(1000)

    private let weatherDataSubject = PassthroughSubject<WeatherData, Never>()

    private lazy var geocoder = CLGeocoder()

    private var cancellable = Set<AnyCancellable>()

    private var refreshTimer: Timer?

    func startUpdating() -> AnyPublisher<WeatherData, Never> {
        NotificationCenter.default.publisher(for: NSLocale.currentLocaleDidChangeNotification)
            .sink { _ in
                self.refreshWeatherInformation()
            }
            .store(in: &cancellable)

        try? ReachabilityPublisher.shared
            .startNotifier()
            .filter { $0.connection != .unavailable }
            .sink(receiveValue: { _ in
                self.refreshWeatherInformation()
            })
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
            self.refreshWeatherInformation()
        })
    }

    var location: CLLocation? {
        set {
            guard let location = newValue else { return }
            if let lastUpdateLocation = weatherData.location, refreshDistance > CLLocation(lastUpdateLocation).distance(from: location) { return }
            weatherData.location = .init(location)

            geocoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
                guard let placemark = placemarks?.first,
                      let locality = placemark.locality,
                      !locality.isEmpty,
                      self.weatherData.location?.name != locality else { return }

                print()
                NSLog("Geocode-Location: \(placemark)")

                self.weatherData.location?.name = locality
            })

            refreshWeatherInformation()
        }
        get {
            guard let location = weatherData.location else { return nil }
            return CLLocation(location)
        }
    }

    private var weatherData = WeatherData() {
        didSet {
            weatherDataSubject.send(weatherData)
        }
    }

    func refreshWeatherInformation() {
        stopRefreshTimer()
        defer { startRefreshTimer() }

        guard let requestURL = requestURL else { return }

        URLSession.shared.dataTaskPublisher(for: requestURL)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {
                if case let .failure(error) = $0, self.weatherData.condition == nil {
                    self.handleDownloadError(error.localizedDescription)
                }
            }, receiveValue: { data, response in
                do {
                    let response = try JSONDecoder().decode(OpenWeatherResponse.self, from: data)
                    guard let weatherData = WeatherData(response: response) else { return assertionFailure() }

                    let location: WeatherData.Location? = {
                        guard let location = self.weatherData.location, location.name != nil,
                              let newLocation = weatherData.location,
                              self.refreshDistance > CLLocation(location).distance(from: CLLocation(newLocation)) else { return weatherData.location }
                        return location
                    }()

                    let newWeatherData = WeatherData(condition: weatherData.condition, temperature: weatherData.temperature, temperatureRange: weatherData.temperatureRange, location: location, date: weatherData.date)
                    self.weatherData = newWeatherData
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
<<<<<<< HEAD
<<<<<<< HEAD
        guard let currentLocation = currentLocation else { return nil }
=======
        guard let location = location else { assertionFailure(); return nil }
>>>>>>> cleanup code, use CLGeocoder

=======
>>>>>>> improve code
        var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")!
        urlComponents.queryItems = [
            URLQueryItem(name: "appid", value: "5d20c08f748c06727dbdacc4d6dd2c42"),
            URLQueryItem(name: "lat", value: String(format: "%f", location?.coordinate.latitude ?? 0)),
            URLQueryItem(name: "lon", value: String(format: "%f", location?.coordinate.longitude ?? 0)),
            URLQueryItem(name: "units", value: temperatureUnit == .celsius ? "metric" : "imperial"),
        ]

        return urlComponents.url
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
}

private extension WeatherData {
    init?(response: OpenWeatherResponse) {
        assert(response.weather.last != nil)
        guard let weather = response.weather.last else { return nil }

        self.init(condition: weather.icon.condition, temperature: response.main.temp, temperatureRange: response.main.temp_min ..< response.main.temp_max, location: .init(name: response.name, coordinate: .init(latitude: response.coord.lat, longitude: response.coord.lon)), date: Date(timeIntervalSince1970: response.dt))
    }
}

private extension CLLocation {
    convenience init(_ location: WeatherData.Location) {
        self.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
}

private extension WeatherData.Location {
    init(_ location: CLLocation) {
        self.init(name: nil, coordinate: .init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
    }
}
