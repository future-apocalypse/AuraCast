//
//  WelcomeView.swift
//  AuraCast
//
//  Created by Mihail Verejan on 21.07.2025.
//

import SwiftUI


struct WelcomeView: View {
    @State private var showNext = false
    @State private var zoomTrigger = false
    @State private var hideUI = false

    var body: some View {
        if showNext{
            FindLocationView()
        }else{
            ZStack {
                Image("aura_cast")
                .resizable()
                .ignoresSafeArea()
                .zoomEffect(trigger: zoomTrigger, scale: 7.0, duration: 0.5)
                if !hideUI {
                    VStack {
                        Spacer().frame(height: 10)
                        VStack(){
                            Text("WEATHER, REIMAGINED.")
                                .font(.system(size: 30))
                                .fontWeight(.light)
                                .foregroundColor(.white)
                                .padding()
                        }
                        VStack(){
                            Text("AuraCast")
                                .font(.system(size: 40))
                                .fontWeight(.ultraLight)
                                .italic()
                                .foregroundColor(.white)
                                .shadow(radius: 5)
                                .padding()
                        }
                        .multilineTextAlignment(.center)
                        .padding()
                        .padding(.top, 50)
                        .padding(.bottom, 50)
                        VStack{
                            Spacer().frame(height: 10)
                            
                            Button(action: {
                                hideUI = true
                                zoomTrigger = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
                                    withAnimation {
                                        showNext = true
                                    }
                                }}) {
                                    HStack {
                                        //Text("Get Started")
                                        Image(systemName: "arrow.right")
                                            .shadow(radius: 5)
                                    }
                                    
                                    .font(.system(size: 20, weight: .medium, design: .monospaced))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 14)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 50)
                                            .stroke(Color.white, lineWidth: 5)
                                    )
                            }
                            .background(Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                                }
                        }
                       }
                }
             }
            }
        }
            
    

#Preview {
    WelcomeView()
}
