//
//  WelcomeView.swift
//  AuraCast
//
//  Created by Mihail Verejan on 21.07.2025.
//

import SwiftUI


struct WelcomeView: View {
    @State private var showNext = false

    var body: some View {
        if showNext{
            FindLocationView()
        }else{
            ZStack {
                Image("aura_cast")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                VStack {
                    VStack(spacing: 10){
                        Text("Welcome to")
                            .font(.system(size: 50))
                        Text("AuraCast")
                            .font(.system(size: 40).italic())
                            .padding()
                        Text("The app that will show you just what you trully need")
                            .font(.system(size: 20).italic())
                    }
                    .multilineTextAlignment(.center)
                    .padding()
                    
                    Button(action: {
                        withAnimation {
                            showNext = true
                        }
                    }) {
                        HStack {
                            Text("Get Started")
                            Image(systemName: "arrow.right")
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(12)
                    }
                }
            }
            }
        }
            
    }

#Preview {
    WelcomeView()
}
