//
//  ErrorView.swift
//  Demo
//
//  Created by Brad Lindsay on 3/8/23.
//

import SwiftUI

struct ErrorView: View {
    let status: Int
    let retryAction: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .resizable().scaledToFit().frame(maxWidth: 38)
                .foregroundColor(Color("Tint"))
            Text("Error loading page")
                .font(.largeTitle)
            Text("There wasn an HTTP error (\(status))")
            Button("Retry", action: retryAction)
                .foregroundColor(Color("Tint"))
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(status: 404, retryAction: {})
    }
}
