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
    @Published var navDataStack: [NavigationDatum] = []
    @Published var session: Session!
    
    override init() {
        super.init()
        self.session = SessionGenerator.makeSession(withDelegate: self, pathConfiguration: DemoApp.pathConfiguration)
    }
    
    func navigate(_ proposal: VisitProposal) {
        let navigationDatum = NavigationDatum.proposal(proposal)
        
        if let index = navDataStack.firstIndex(of: navigationDatum) {
            navDataStack.removeSubrange(navDataStack.index(after: index)..<navDataStack.endIndex)
        }
        else {
            if proposal.options.action == .replace && !navDataStack.isEmpty {
                navDataStack.removeLast()
                // Load it up in the current view's WebKit because SwiftUI doesn't seem to re-render
                // the views when the `proposals` array doesn't change size.
                (session.topmostVisitable! as! VisitableViewController).visitableURL = proposal.url
                session.visit(session.topmostVisitable!)
            }
            navDataStack.append(navigationDatum)
        }
    }
    
    func session(_ session: Turbo.Session, didProposeVisit proposal: Turbo.VisitProposal) {
        guard let viewController = proposal.properties["view-controller"] as? String else {
            self.navigate(proposal)
            return
        }
        
        switch viewController {
        case "numbers":
            navDataStack.append(.numbers)
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
        case 404:
            navDataStack.removeLast()
            navDataStack.append(.httpError(404))
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
                navDataStack.append(.imageURL(url))
            } else {
                UIApplication.shared.open(url)
            }
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

