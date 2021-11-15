//
//  SymbolRow.swift
//  SFSymbolsPreview
//
//  Created by Richard Witherspoon on 11/15/21.
//

import SwiftUI
import SFSymbols


struct SymbolRow: View{
    let symbol: SFSymbol
    
    var body: some View{
        Text("iOS")
            .badge(symbol.releaseInfo.iOS.formatted())
        Text("macOS")
            .badge(symbol.releaseInfo.macOS.formatted())
        Text("tvOS")
            .badge(symbol.releaseInfo.tvOS.formatted())
        Text("watchOS")
            .badge(symbol.releaseInfo.watchOS.formatted())
        if let categories = symbol.categories{
            Text("Categories")
                .badge(categories.map(\.title).formatted(.list(type: .and)))
        }
        if let searchTerms = symbol.searchTerms{
            Text("Search Terms")
                .badge(searchTerms.formatted(.list(type: .and)))
        }
    }
}


struct SymbolRow_Previews: PreviewProvider {
    static var previews: some View {
        Form{
            Section{
                SymbolRow(symbol: .trash)
            } header: {
                Label("Trash", systemImage: "trash")
            }
        }
    }
}
