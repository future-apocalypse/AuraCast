//
//  WeatherManager.swift
//  AuraCast
//
//  Created by Mihail Verejan on 21.07.2025.
//

import Foundation
import CoreLocation

class WeatherManager {
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        guard let apiKey = Bundle.main.infoDictionary?["WEATHER_API_KEY"] as? String else {
            fatalError("Missing API Key")
        }

        guard let url = URL(string: "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(latitude),\(longitude)") else {
            fatalError("Missing URL")
        }

        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Failed to fetch weather data.")
        }

        let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
        return decodedData
    }
    func getCurrentWeather(forCity city: String) async throws -> ResponseBody {
        guard let apiKey = Bundle.main.infoDictionary?["WEATHER_API_KEY"] as? String else {
            fatalError("Missing API Key")
        }

        let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        guard let url = URL(string: "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(cityEncoded)") else {
            fatalError("Invalid URL")
        }

        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Failed to fetch data")
        }

        return try JSONDecoder().decode(ResponseBody.self, from: data)
    }
    
    func get7DayForecast(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ForecastResponse {
        guard let apiKey = Bundle.main.infoDictionary?["WEATHER_API_KEY"] as? String else {
            fatalError("Missing API Key")
        }

        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(latitude),\(longitude)&days=7"
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }

        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Failed to fetch forecast data.")
        }

        return try JSONDecoder().decode(ForecastResponse.self, from: data)
    }
}




//Too lazy, Chat helped here )
struct ResponseBody: Codable {
    let location: Location
    let current: Current

    struct Location: Codable {
        let name: String
        let region: String
        let country: String
        let lat: Double
        let lon: Double
        let localtime: String
    }

    struct Current: Codable {
        let temp_c: Double
        let condition: Condition
        let wind_kph: Double
        let humidity: Int
        let feelslike_c: Double
        let uv: Double
        let precip_mm: Double
    }

    struct Condition: Codable {
        let text: String
        let icon: String
        let code: Int
    }
}


struct ForecastResponse: Codable {
    let forecast: Forecast
}

struct Forecast: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable, Identifiable {
    let date: String
    let day: Day

    var id: String { date }
}

struct Day: Codable {
    let maxtemp_c: Double
    let mintemp_c: Double
    let condition: ResponseBody.Condition
}
