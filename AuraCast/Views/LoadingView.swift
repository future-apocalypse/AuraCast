//
//  LoadingView.swift
//  AuraCast
//
//  Created by Mihail Verejan on 21.07.2025.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .frame(maxWidth: . infinity, maxHeight: . infinity)
    }
}

#Preview {
    LoadingView()
}
