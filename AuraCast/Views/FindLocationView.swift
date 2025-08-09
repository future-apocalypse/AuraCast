//
//  FindLocationView.swift
//  AuraCast
//
//  Created by Mihail Verejan on 21.07.2025.
//

import SwiftUI
import CoreLocationUI
import Combine

struct FindLocationView: View {
    @EnvironmentObject var locationManager: LocationManager
    @State private var cityName = ""
    @State private var weather: ResponseBody?
    @State private var isLoading = false
    @State private var fetchFailed = false
    @State private var showWeather = false
    @State private var hasCheckedLocation = false
    @State private var locationObserver: AnyCancellable?
    @State private var authorizationObserver: AnyCancellable?

    let weatherManager = WeatherManager()

    var body: some View {
        ZStack {
            Image("bg_location")
                .resizable()
                .ignoresSafeArea()
            
            if showWeather, let weather = weather {
                WeatherView(weather: weather)
            } else {
                VStack(spacing: 30) {
                    Spacer()
                    Text("WHERE ARE ")
                        .font(.system(size: 40))
                        .fontWeight(.light)
                        
                    +
                    Text("YOU")
                        .font(.system(size: 40))
                        .italic()
                        .foregroundColor(.orange)
                    +
                    Text(" ?")
                        .font(.system(size: 40))
                    
                    Text("We will find the weather for you")
                        .font(.system(size: 40))
                        .fontWeight(.ultraLight)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .padding(.top)
                        
                        .padding(.bottom, 50)
                    Button(action: {
                        locationManager.requestLocation()
                    }) {
                        Text("FIND ME")
                            .font(.system(size: 20, weight: .medium, design: .monospaced))
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 14)
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color.white, lineWidth: 5)
                            )
                    }
                    .background(Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                    Spacer()

                    if isLoading {
                        ProgressView("Fetching...")
                    }
                    
                    if fetchFailed {
                        Text("Could not find weather for that city.")
                            .foregroundColor(.red)
                    }
                }
                .multilineTextAlignment(.center)
                .padding()
            }
        }
        .onAppear {
            setupLocationObserver()
            
            if !hasCheckedLocation, let location = locationManager.location {
                hasCheckedLocation = true
                Task {
                    await fetchWeatherForLocation(latitude: location.latitude, longitude: location.longitude)
                }
            }
        }
        .onDisappear {
            locationObserver?.cancel()
            authorizationObserver?.cancel()
        }
    }
    
    private func setupLocationObserver() {
        locationObserver = NotificationCenter.default.publisher(for: .init("LocationUpdated"))
            .sink { _ in
                if let location = locationManager.location {
                    Task {
                        await fetchWeatherForLocation(latitude: location.latitude, longitude: location.longitude)
                    }
                }
            }
        
        authorizationObserver = NotificationCenter.default.publisher(for: .init("LocationAuthorizationChanged"))
            .sink { _ in
                if (locationManager.authorizationStatus == .authorizedWhenInUse ||
                    locationManager.authorizationStatus == .authorizedAlways) && 
                    locationManager.location != nil {
                    
                }
            }
    }
    
    func fetchWeatherForLocation(latitude: Double, longitude: Double) async {
        isLoading = true
        fetchFailed = false

        do {
            let result = try await weatherManager.getCurrentWeather(
                latitude: latitude,
                longitude: longitude
            )
            await MainActor.run {
                self.weather = result
                self.isLoading = false
                self.showWeather = true
            }
        } catch {
            print("Error fetching weather by location:", error)
            await MainActor.run {
                self.fetchFailed = true
                self.isLoading = false
            }
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
        .environmentObject(LocationManager())
}
