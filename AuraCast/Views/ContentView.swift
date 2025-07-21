//
//  ContentView.swift
//  AuraCast
//
//  Created by Mihail Verejan on 20.07.2025.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?
    
    
    var body: some View {
        VStack {
            if let location = locationManager.location {
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
                    WelcomeView()
                        .environmentObject(locationManager)
                }
            }
            
        }
        //.background(Color.blue)
    }
}

#Preview {
    ContentView()
}

