//
//  TurboUIWrapperView.swift
//  Demo
//
//  Created by Brad Lindsay on 3/8/23.
//

import SwiftUI
import Turbo

struct TurboUIWrapperView: UIViewControllerRepresentable {
    let session: Session
    let proposal: VisitProposal
    @Binding var title: String?

    func makeUIViewController(context: Context) -> VisitableSwiftUIController {
        let viewController = VisitableSwiftUIController(turboView: self)
        session.visit(viewController, options: proposal.options)
        return viewController
    }

    func updateUIViewController(_ viewController: VisitableSwiftUIController, context: Context) {}
}

extension TurboUIWrapperView {
    init(session: Session, url: URL, title: Binding<String?> = Binding.constant(nil)) {
        self.session = session
        self.proposal = VisitProposal(url: url, options: VisitOptions())
        self._title = title
    }
}
