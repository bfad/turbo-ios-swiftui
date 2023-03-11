//
//  TurboModalHelper.swift
//  Demo
//
//  Created by Brad Lindsay on 3/10/23.
//

import SwiftUI
import Turbo

class TurboModalHelper: ObservableObject {
    @Published var session: Session!
    @Published var display = false
    @Published var proposal: VisitProposal?
    
    @ViewBuilder
    var content: some View {
        if let proposal = proposal {
            NavigationStack {
                TurboView(session: session, proposal: proposal)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(leading: Button("Done") { self.display = false })
            }.accentColor(Color("Tint"))
        } else {
            EmptyView()
        }
    }
    
    init() {
        self.session = SessionGenerator.makeSession(pathConfiguration: DemoApp.pathConfiguration)
    }
}
