//
//  GradientsManager.swift
//  AuraCast
//
//  Created by Mihail Verejan on 22.07.2025.
//

import Foundation


func backgroundImageName(for condition: String) -> String {
    let lowercased = condition.lowercased()

    if lowercased.contains("sunny") || lowercased.contains("clear") {
        return "bg_sunny"
    } else if lowercased.contains("cloud") {
        return "bg_cloudy"
    } else if lowercased.contains("rain") || lowercased.contains("drizzle") {
        return "bg_rainy"
    } else if lowercased.contains("thunder") {
        return "bg_stormy"
    } else if lowercased.contains("snow") || lowercased.contains("sleet") {
        return "bg_snowy"
    } else if lowercased.contains("fog") || lowercased.contains("mist") || lowercased.contains("haze") {
        return "bg_foggy"
    } else if lowercased.contains("hot") {
        return "bg_sunny"
    } else if lowercased.contains("cold") {
        return "bg_cloudy"
    }

    return "bg_sunny"
}
