//
//  TurboView.swift
//  Demo
//
//  Created by Brad Lindsay on 3/8/23.
//

import SwiftUI
import Turbo

struct TurboView: UIViewControllerRepresentable {
    let session: Session
    let proposal: VisitProposal
    
    public init(session: Session, url: URL) {
        self.session = session
        self.proposal = VisitProposal(url: url, options: VisitOptions())
    }
    
    public init(session: Session, proposal: VisitProposal) {
        self.session = session
        self.proposal = proposal
    }

    func makeUIViewController(context: Context) -> VisitableSwiftUIController {
        let viewController = VisitableSwiftUIController(url: proposal.url)
        session.visit(viewController, options: proposal.options)
        return viewController
    }

    func updateUIViewController(_ viewController: VisitableSwiftUIController, context: Context) {}
}

class VisitableSwiftUIController: VisitableViewController {
    override func visitableDidRender() {
        // In order to get the navigation title to be set, we must set it on the parent
        // wrapper that SwiftUI creates
        self.parent?.navigationItem.title = visitableView.webView?.title
    }
}
