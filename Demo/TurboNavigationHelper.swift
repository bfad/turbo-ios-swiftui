//
//  TurboNavigationHelper.swift
//  Demo
//
//  Created by Brad Lindsay on 3/8/23.
//

import SwiftUI
import WebKit
import UniformTypeIdentifiers
import Turbo

class TurboNavigationHelper: NSObject, ObservableObject, SessionDelegate {
    @Published var session: Session!
    @Published var stack: NavStack<NavigationDatum> = []
    var rootProposal = VisitProposal(
        url: DemoApp.baseURL.appendingPathComponent("/"),
        options: VisitOptions()
    )
    var turboModal: TurboModalHelper? {
        didSet {
            turboModal?.session.delegate = self
        }
    }
    
    override init() {
        super.init()
        self.session = SessionGenerator.makeSession(withDelegate: self, pathConfiguration: DemoApp.pathConfiguration)
    }
    
    func navigate(_ proposal: VisitProposal) {
        if proposal.url == rootProposal.url {
            rootProposal = proposal
            if stack.count == 0 {
                session.reload()
            } else {
                stack.removeAll()
            }
            return
        }

        let navigationDatum = NavigationDatum.proposal(proposal)
        guard proposal.options.action == .replace else {
            stack.appendOrPopTo(navigationDatum)
            return
        }
        
        // Load it up in the current view's WebKit because SwiftUI doesn't seem to re-render
        // the views when the `proposals` array doesn't change size.
        (session.topmostVisitable! as! VisitableSwiftUIController).visitableURL = proposal.url
        session.visit(session.topmostVisitable!)
        stack.replaceLast(with: navigationDatum)
    }
    
    func session(_ session: Turbo.Session, didProposeVisit proposal: Turbo.VisitProposal) {
        if let turboModal = turboModal, proposal.properties["presentation"] as? String == "modal" {
            turboModal.proposal = proposal
            turboModal.display = true
            return
        } else {
            // Dismiss the modal
            turboModal?.display = false
        }
        guard let viewController = proposal.properties["view-controller"] as? String else {
            self.navigate(proposal)
            return
        }
        
        switch viewController {
        case "numbers":
            stack.appendOrPopTo(.numbers)
        default:
            assertionFailure("Invalid view controller, defaulting to WebView")
            self.navigate(proposal)
        }
    }
    
    func sessionDidLoadWebView(_ session: Session) {
        session.webView.navigationDelegate = self
    }
    
    func sessionWebViewProcessDidTerminate(_ session: Turbo.Session) {
        // This helps fix occaisional hangs when switching back to the app
        // https://github.com/hotwired/turbo-ios/issues/8#issuecomment-1283743955
        session.reload()
    }
    
    func session(_ session: Turbo.Session, didFailRequestForVisitable visitable: Turbo.Visitable, error: Error) {
        print(error.localizedDescription)
        
        guard let turboError = error as? TurboError, case let .http(statusCode) = turboError else {
            return
        }
        switch statusCode {
        case 401:
            let proposal = VisitProposal(
                url: DemoApp.baseURL.appendingPathComponent("signin"),
                options: VisitOptions()
            )
            turboModal!.proposal = proposal
            turboModal!.display = true
        case 404:
            stack.replaceLast(with: .httpError(404))
        default:
            // TODO: Something
            print(statusCode)
        }
    }
}

enum NavigationDatum: Hashable {
    case proposal(VisitProposal), imageURL(URL), httpError(Int), numbers
}

extension TurboNavigationHelper: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            // Any link that's not on the same domain as the Turbo root url will go through here
            // Other links on the domain, but that have an extension that is non-html will also go here
            // You can decide how to handle those, by default if you're not the navigationDelegate
            // the Session will open them in the default browser
            
            let url = navigationAction.request.url!
            
            // For this demo, we'll load files from our domain in a SafariViewController so you
            // don't need to leave the app. You might expand this in your app
            // to open all audio/video/images in a native media viewer
            if url.host == DemoApp.baseURL.host, let mime = UTType(filenameExtension: url.pathExtension)?.preferredMIMEType, mime.starts(with: "image/") {
                stack.appendOrPopTo(.imageURL(url))
            } else {
                UIApplication.shared.open(url)
            }
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

