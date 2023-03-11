//
//  DemoApp.swift
//  Demo
//
//  Created by Brad Lindsay on 3/8/23.
//

import SwiftUI
import Turbo

@main
struct DemoApp: App {
    private static let basic = URL(string: "https://turbo-native-demo.glitch.me")!
    private static let local = URL(string: "http://localhost:45678")!
    static let baseURL = local
    static let userAgent = "Turbo Native iOS/2.0"
    
    static var pathConfiguration = PathConfiguration(sources: [
        .file(Bundle.main.url(forResource: "path-configuration", withExtension: "json")!),
    ])
    
    @StateObject var modalData = TurboModalHelper()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modalData)
                .sheet(isPresented: $modalData.display) {
                    modalData.content
                }
        }
    }
}
