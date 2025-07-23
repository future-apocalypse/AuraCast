//
//  ZoomExtension.swift
//  AuraCast
//
//  Created by Mihail Verejan on 23.07.2025.
//

import SwiftUI

struct ZoomEffect: ViewModifier {
    let trigger: Bool
    var scale: CGFloat = 1.2
    var duration: Double = 1.0

    func body(content: Content) -> some View {
        content
            .scaleEffect(trigger ? scale : 1)
            .animation(.easeInOut(duration: duration), value: trigger)
    }
}

extension View {
    func zoomEffect(trigger: Bool, scale: CGFloat = 1.2, duration: Double = 1.0) -> some View {
        self.modifier(ZoomEffect(trigger: trigger, scale: scale, duration: duration))
    }
}
