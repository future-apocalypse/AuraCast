//
//  ContentView.swift
//  AuraCast
//
//  Created by Mihail Verejan on 20.07.2025.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore = false
    @StateObject private var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?
    
    var body: some View {
        VStack {
            if !hasLaunchedBefore {
                WelcomeView()
                    .environmentObject(locationManager)
                    .onDisappear {
                        hasLaunchedBefore = true
                    }
            } else if let location = locationManager.location {
                if let weather = weather {
                    WeatherView(weather: weather)
                } else {
                    LoadingView()
                        .task {
                            do {
                                weather = try await weatherManager.getCurrentWeather(
                                    latitude: location.latitude,
                                    longitude: location.longitude
                                )
                            } catch {
                                print("Error getting weather data: \(error)")
                            }
                        }
                }
            } else {
                if locationManager.isLoading {
                    LoadingView()
                } else {
                    FindLocationView()
                        .environmentObject(locationManager)
                }
            }
        }
        .onAppear {
            setupWeatherUpdateNotification()
            
            if hasLaunchedBefore && locationManager.location == nil {
                locationManager.requestLocation()
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    private func setupWeatherUpdateNotification() {
        NotificationCenter.default.addObserver(
            forName: Notification.Name("WeatherUpdated"),
            object: nil,
            queue: .main
        ) { notification in
            if let newWeather = notification.userInfo?["weather"] as? ResponseBody {
                self.weather = newWeather
            }
        }
    }
}

#Preview {
    ContentView()
}

