//
//  ContentView.swift
//  newClips
//
//  Created by Ankit on 12/18/25.
//

import SwiftUI

struct ContentView: View {
    init() {
        print("App Clip launched")
    }
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
