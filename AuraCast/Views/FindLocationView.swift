//
//  FindLocationView.swift
//  AuraCast
//
//  Created by Mihail Verejan on 21.07.2025.
//

import SwiftUI
import CoreLocationUI

struct FindLocationView: View {
    @EnvironmentObject var locationManager: LocationManager
    @State private var cityName = ""
    @State private var weather: ResponseBody?
    @State private var isLoading = false
    @State private var fetchFailed = false
    @State private var showWeather = false

    let weatherManager = WeatherManager()

    var body: some View {
        if showWeather, let weather = weather {
            WeatherView(weather: weather)
        } else {
            VStack(spacing: 20) {
                Text("Find your weather")
                    .font(.title2)
                    .padding(.top)

                // Use current location
                LocationButton(.shareCurrentLocation) {
                    locationManager.requestLocation()
                }
                .cornerRadius(10)
                .symbolVariant(.fill)
                .foregroundColor(.white)

                Text("or")
                    .foregroundColor(.gray)

                // Manual city input
                TextField("Enter a city name", text: $cityName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                Button("Search") {
                    Task {
                        await fetchWeather()
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                
                if isLoading {
                    ProgressView("Fetching...")
                }

                if fetchFailed {
                    Text("Could not find weather for that city.")
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
    }

    func fetchWeather() async {
        isLoading = true
        fetchFailed = false

        do {
            let result = try await weatherManager.getCurrentWeather(forCity: cityName)
            await MainActor.run {
                self.weather = result
                self.isLoading = false
                self.showWeather = true
            }
        } catch {
            print("Error fetching weather by city:", error)
            await MainActor.run {
                self.fetchFailed = true
                self.isLoading = false
            }
        }
    }
}

#Preview {
    FindLocationView()
}
