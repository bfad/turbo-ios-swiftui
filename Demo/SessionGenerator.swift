//
//  SessionGenerator.swift
//  Demo
//
//  Created by Brad Lindsay on 3/8/23.
//

import WebKit
import Turbo

struct SessionGenerator {
    private static let sharedProcessPool = WKProcessPool()
    
    public static func makeSession(withDelegate delegate: SessionDelegate, pathConfiguration: PathConfiguration = PathConfiguration()) -> Session {
        let configuration = WKWebViewConfiguration()
        configuration.applicationNameForUserAgent = DemoApp.userAgent
        configuration.processPool = Self.sharedProcessPool

        let session = Session(webViewConfiguration: configuration)
        session.webView.allowsLinkPreview = false
        session.delegate = delegate
        session.pathConfiguration = pathConfiguration

        return session
    }
}
