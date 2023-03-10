//
//  VisitableSwiftUIController.swift
//  Demo
//
//  Created by Brad Lindsay on 3/10/23.
//

import SwiftUI
import Turbo

class VisitableSwiftUIController: VisitableViewController {
    var turboView: TurboUIWrapperView!

    convenience init(turboView: TurboUIWrapperView) {
        self.init(url: turboView.proposal.url)
        self.turboView = turboView
    }
    
    override func visitableDidRender() {
        turboView.title = visitableView.webView?.title
    }
}
