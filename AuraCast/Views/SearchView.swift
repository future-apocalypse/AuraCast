//
//  SearchView.swift
//  AuraCast
//
//  Created by Mihail Verejan on 27.07.2025.
//

import SwiftUI

struct SearchView: View {
    @Binding var isPresented: Bool
    @Binding var searchText: String
    var onCitySelected: (String) -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    
                    Button("Search for \(searchText)") {
                        onCitySelected(searchText)
                        isPresented = false
                    }
                }
                .searchable(text: $searchText)
                .navigationTitle("Search")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct SearchModalView: View {
    @Binding var searchText: String
    @Environment(\.dismiss) var dismiss
    var onSearch: (String) -> Void

    var body: some View {
        NavigationStack {
            List {
                if !searchText.isEmpty {
                    Button("Search for \(searchText)") {
                        onSearch(searchText)
                        dismiss()
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Enter city name")
            .navigationTitle("Search Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                    }
                }
            }
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

