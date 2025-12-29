//
//  Swift_appApp.swift
//  Swift app
//
//  Created by Ankit on 12/11/25.
//

import SwiftUI

@main
struct Swift_appApp: App {
    @StateObject private var authState = AuthState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authState)

        }
    }
}

