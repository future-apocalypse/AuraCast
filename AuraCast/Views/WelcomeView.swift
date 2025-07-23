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
                        Spacer().frame(height: 60)
                        VStack(){
                            Text("Weather, reimagined.")
                                .font(.system(size: 30))
                                .fontWeight(.ultraLight)
                                .foregroundColor(.white)
                                .shadow(radius: 5)
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
                        .padding(.top, 90)
                        VStack{
                            Spacer().frame(height: 70)
                            
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
                                    
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.drop)
                                    .cornerRadius(100)
                                    .shadow(color: Color.blue.opacity(0.5) ,radius: 10)
                                }
                        }
                        Spacer().frame(height: 100)
                    }
                }
             }
            }
        }
            
    }

#Preview {
    WelcomeView()
}
