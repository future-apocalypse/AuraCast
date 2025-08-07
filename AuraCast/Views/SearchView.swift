//
//  SearchView.swift
//  AuraCast
//
//  Created by Mihail Verejan on 27.07.2025.
//

import SwiftUI

struct City: Identifiable, Codable {
    var id: Int { name.hashValue ^ country.hashValue ^ region.hashValue }
    let name: String
    let region: String
    let country: String
}

struct SearchView: View {
    @Binding var isPresented: Bool
    @Binding var searchText: String
    var onCitySelected: (String) -> Void
    
    @State private var suggestions: [City] = []
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(suggestions) { city in
                    Button(action: {
                        onCitySelected(city.name)
                        isPresented = false
                    }) {
                        Text("\(city.name), \(city.region), \(city.country)")
                            .foregroundColor(.white)
                    }
                }
                
                if !searchText.isEmpty && suggestions.isEmpty {
                    Button("Search for \"\(searchText)\"") {
                        onCitySelected(searchText)
                        isPresented = false
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Enter city name")
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
            }
            .onChange(of: searchText) { oldValue, newValue in
                Task {
                    await fetchSuggestions(for: newValue)
                }
            }
        }
    }
    
    // MARK: API Call
    func fetchSuggestions(for query: String) async {
        guard !query.isEmpty else {
            await MainActor.run {
                self.suggestions = []
            }
            return
        }

        guard let apiKey = Bundle.main.infoDictionary?["WEATHER_API_KEY"] as? String else { return }

        guard let url = URL(string: "https://api.weatherapi.com/v1/search.json?key=\(apiKey)&q=\(query)") else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode([City].self, from: data)

            await MainActor.run {
                self.suggestions = decoded
            }
        } catch {
            print("Suggestion fetch failed: \(error)")
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    @State static var isPresented = true
    @State static var searchText = ""
    
    static var previews: some View {
        SearchView(isPresented: $isPresented, searchText: $searchText, onCitySelected: { _ in })
    }
}
