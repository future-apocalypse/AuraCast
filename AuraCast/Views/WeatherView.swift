//
//  WeatherView.swift
//  AuraCast
//
//  Created by Mihail Verejan on 21.07.2025.
//

import SwiftUI

struct WeatherView: View {
    var weather: ResponseBody
    
    var body: some View {
        VStack {
            Text(weather.location.name)
            Text("\(weather.current.temp_c, specifier: "%.1f")°C")
            Text(weather.current.condition.text)
        }
    }
}

#Preview {
    WeatherView(weather: ResponseBody(
        location: .init(name: "Tokyo", region: "Kanto", country: "Japan", lat: 35.0, lon: 139.0, localtime: "2025-07-21 21:00"),
        current: .init(temp_c: 32.2, condition: .init(text: "Cloudy", icon: "//cdn.weatherapi.com/weather/64x64/day/116.png", code: 1003), wind_kph: 14.0, humidity: 60, feelslike_c: 34.0)
    ))
   
}
