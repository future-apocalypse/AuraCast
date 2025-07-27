//
//  SearchView.swift
//  AuraCast
//
//  Created by Mihail Verejan on 27.07.2025.
//

import SwiftUI

struct SearchView: View {
    @State var presentSheet = false
    @State private var searchText = ""
    
    
    
    var body: some View {
        
        Button("Modal") {
            presentSheet = true
        }
        .navigationTitle("Main")
        .sheet(isPresented: $presentSheet) {
            SearchModalView(searchText: $searchText)
                .presentationDetents([.medium])
            
        }
    }
}

struct SearchModalView: View {
    @Binding var searchText: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            List {
                Text("Searching for \(searchText)")
            }
            .searchable(text: $searchText)
            .navigationTitle("Location")
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

#Preview {
    SearchView()
}
