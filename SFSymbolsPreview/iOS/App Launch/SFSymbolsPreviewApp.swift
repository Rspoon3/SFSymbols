//
//  SFSymbolsPreviewApp.swift
//  SFSymbolsPreview
//
//  Created by Richard Witherspoon on 11/15/21.
//

import SwiftUI

@main
struct SFSymbolsPreviewApp: App {
    @StateObject private var model = ContentViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
