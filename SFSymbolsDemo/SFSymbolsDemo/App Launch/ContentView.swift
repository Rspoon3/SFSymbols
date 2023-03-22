//
//  ContentView.swift
//  SFSymbolsDemo
//
//  Created by Richard Witherspoon on 11/15/21.
//

import SwiftUI


struct ContentView: View {
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
#endif
    
    var body: some View {
#if os(iOS)
        if horizontalSizeClass == .compact {
            AppTabNavigation()
        } else {
            AppSidebarNavigation()
        }
#else
        AppSidebarNavigation()
            .frame(minWidth: 600, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
#endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
