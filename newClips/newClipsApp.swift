//
//  newClipsApp.swift
//  newClips
//
//  Created by Ankit on 12/18/25.
//

import SwiftUI

@main
struct newClipsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { userActivity in
                                    guard let incomingURL = userActivity.webpageURL else { return }
                                    handleURL(incomingURL)
                                }
        }
    }
    func handleURL(_ url: URL) {
            // Use URL components to navigate to a specific screen
            // Example: https://example.com/order?item=123
            print("App Clip launched with: \(url.absoluteString)")
        }
}
