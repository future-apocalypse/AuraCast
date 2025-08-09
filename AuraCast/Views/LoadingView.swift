//
//  LoadingView.swift
//  AuraCast
//
//  Created by Mihail Verejan on 21.07.2025.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    var body: some View {
        ZStack {
           Image("bg_location")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Circle()
                            .trim(from: 0, to: 0.5)
                            .stroke(Color.white, lineWidth: 1.5)
                            .frame(width: 25, height: 25)
                            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                            .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                            .onAppear { isAnimating = true }
                
                
                Text("Looking outside for you")
                    .font(.system(size: 40))
                    .fontWeight(.ultraLight)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                    }
                
               
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
#Preview {
    LoadingView()
}
