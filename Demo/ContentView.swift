//
//  ContentView.swift
//  Demo
//
//  Created by Brad Lindsay on 3/8/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var navHelper = TurboNavigationHelper()
    @EnvironmentObject var modalData: TurboModalHelper

    var body: some View {
        NavigationStack(path: $navHelper.stack) {
            TurboView(session: navHelper.session, url: DemoApp.baseURL)
                .navigationDestination(for: NavigationDatum.self) { datum in
                    switch datum {
                    case .proposal(let proposal):
                        TurboView(session: navHelper.session, proposal: proposal)
                            .navigationBarTitleDisplayMode(.inline)
                    case .imageURL(let url):
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFit()
                        }
                        placeholder: {
                            Text("Loading")
                        }
                    case .numbers:
                        NumbersListView()
                    case .httpError(let status):
                        ErrorView(status: status, retryAction: {
                            navHelper.session.reload()
                        })
                    }
                }
        }
        .accentColor(Color("Tint"))
        .onAppear() {
            navHelper.turboModal = modalData
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
