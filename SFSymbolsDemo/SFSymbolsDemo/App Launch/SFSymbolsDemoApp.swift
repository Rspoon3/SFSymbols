//
//  SFSymbolsDemoApp.swift
//  SFSymbolsDemo
//
//  Created by Richard Witherspoon on 3/22/23.
//

import SwiftUI

@main
struct SFSymbolsDemoApp: App {
    @StateObject private var model = ContentViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
