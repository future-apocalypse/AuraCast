//
//  WeatherView.swift
//  AuraCast
//
//  Created by Mihail Verejan on 21.07.2025.
//

import SwiftUI

import SwiftUI

struct WeatherView: View {
    let weather: ResponseBody
    @State private var forecast: ForecastResponse?
    let weatherManager = WeatherManager()

    var body: some View {
        ZStack {
            Image(backgroundImageName(for: weather.current.condition.text))
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 12) {
                Spacer()

                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: symbolName(for: weather.current.condition.text))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                        
                        VStack(alignment: .leading) {
                            Text(weather.location.name)
                                .font(.headline)

                            Text(weather.location.localtime.suffix(5))
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Text(weather.current.condition.text)
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        
                        Spacer()

                        Text("\(Int(weather.current.temp_c.rounded()))°C")
                            .font(.system(size: 42, weight: .light))
                            .padding(.trailing)
                    }

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 5) {
                        InfoBox(icon: "wind", label: "Wind", value: "\(String(format: "%.1f", weather.current.wind_kph)) km/h")
                        InfoBox(icon: "humidity", label: "Humidity", value: "\(weather.current.humidity)%")
                        InfoBox(icon: "sun.max", label: "UV Index", value: "\(String(format: "%.0f", weather.current.uv))")
                        InfoBox(icon: "cloud.rain", label: "Rain", value: "\(String(format: "%.1f", weather.current.precip_mm)) mm")
                    }

                    
                    
                    if let forecast = forecast {
                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack(spacing: 5) {
                                ForEach(forecast.forecast.forecastday) { day in
                                    VStack(spacing: 8) {
                                        Text(shortDay(for: day.date))
                                            .font(.caption2)
                                            .foregroundColor(.white)

                                        Image(systemName: symbolName(for: day.day.condition.text))
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.white)

                                        Text("\(Int(day.day.maxtemp_c))°")
                                            .font(.footnote)
                                            .foregroundColor(.white)

                                        Text("\(Int(day.day.mintemp_c))°")
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                            .shadow(radius: 3)
                                    }
                                    .padding()
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(16)
                                }
                            }
                            .padding(.leading)
                        }
                    } else {
                        ProgressView("Loading forecast...")
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(30)
                .shadow(radius: 10)
                .padding(.horizontal)
                    
                
                .task {
                        do {
                            forecast = try await weatherManager.get7DayForecast(
                                latitude: weather.location.lat,
                                longitude: weather.location.lon
                            )
                        } catch {
                            print("Forecast error: \(error)")
                        }
                    }
                }

                //Spacer()
                
            }
        }
    }

let mockWeather = ResponseBody(
    location: .init(
        name: "Chisinau",
        region: "Moldova",
        country: "MD",
        lat: 47.0105,
        lon: 28.8638,
        localtime: "2025-07-25 18:00"
    ),
    current: .init(
        temp_c: 26.5,
        condition: .init(text: "Partly cloudy", icon: "https://cdn.weatherapi.com/weather/64x64/day/116.png", code: 1003),
        wind_kph: 12.3,
        humidity: 68,
        feelslike_c: 27.1,
        uv: 5.0,            
        precip_mm: 0.4
    )
)
func symbolName(for condition: String) -> String {
    let lower = condition.lowercased()

    if lower.contains("sunny") {
        return "sun.max"
    } else if lower.contains("partly") && lower.contains("cloudy") {
        return "cloud.sun"
    } else if lower.contains("cloudy") {
        return "cloud"
    } else if lower.contains("overcast") {
        return "smoke.fill"
    } else if lower.contains("clear") {
        return "moon.stars"
    } else if lower.contains("rain") || lower.contains("drizzle") {
        return "cloud.rain"
    } else if lower.contains("thunder") {
        return "cloud.bolt.rain"
    } else if lower.contains("snow") || lower.contains("sleet") {
        return "snow"
    } else if lower.contains("mist") || lower.contains("fog") || lower.contains("haze") {
        return "cloud.fog"
    } else {
        return "questionmark.circle"
    }
}

struct InfoBox: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading) {
            Label {
                Text(label)
            } icon: {
                Image(systemName: icon)
            }
            .font(.caption)

            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}

func shortDay(for dateString: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    guard let date = formatter.date(from: dateString) else { return "" }
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "E" // Mon, Tue, etc
    return outputFormatter.string(from: date)
}

func iconForForecast(_ day: Int) -> String {
    // You can replace this with actual forecast icon logic
    let icons = ["cloud", "cloud.sun", "cloud.bolt", "sun.max", "cloud", "cloud.rain", "cloud.sun"]
    return icons[day % icons.count]
}


#Preview {
    WeatherView(weather: mockWeather)
}
