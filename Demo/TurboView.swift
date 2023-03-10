//
//  TurboView.swift
//  Demo
//
//  Created by Brad Lindsay on 3/10/23.
//

import SwiftUI
import Turbo

struct TurboView: View {
    let session: Session
    let proposal: VisitProposal
    @State var navTitle: String?
    
    var body: some View {
        if let title = navTitle {
            TurboUIWrapperView(session: session, proposal: proposal, title: $navTitle)
                .navigationBarTitle(Text(title))
        } else {
            TurboUIWrapperView(session: session, proposal: proposal, title: $navTitle)
        }
    }
}

extension TurboView {
    init(session: Session, url: URL, navTitle: String? = nil) {
        self.init(
            session: session,
            proposal: VisitProposal(url: url, options: VisitOptions()),
            navTitle: navTitle
        )
    }
}

struct WrappedTurboView_Previews: PreviewProvider {
    static var previews: some View {
        TurboView(session: TurboNavigationHelper().session, url: DemoApp.baseURL)
    }
}
