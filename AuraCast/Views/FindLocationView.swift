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
                    
                    // Use current location
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
//                    Text("or")
//                        .foregroundColor(.black)
//                    
//                    // Manual city input
//                    TextField("Enter a city name", text: $cityName)
//                        .textFieldStyle(.roundedBorder)
//                        .padding(.horizontal)
//                    
//                    Button("Search") {
//                        Task {
//                            await fetchWeather()
//                        }
//                    }
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
                    
                    
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
