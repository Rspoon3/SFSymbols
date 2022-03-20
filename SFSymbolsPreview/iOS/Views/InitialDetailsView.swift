//
//  InitialDetailsView.swift
//  SFSymbolsPreview
//
//  Created by Richard Witherspoon on 11/18/21.
//

import SwiftUI
import SFSymbols


struct InitialDetailsView: View{
    let symbols: [SFSymbol]
    @State private var searchText = String()
    
    
    func searchResults()->[SFSymbol]{
        if searchText.isEmpty{
            return symbols
        }
        
        return symbols.filter({
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.searchTerms?.contains(where: {$0.localizedCaseInsensitiveContains(searchText)}) ?? false
        })
    }
    
    
    var body: some View{
        List(searchResults().suffix(20)){ symbol in
            Section {
                SymbolRow(symbol: symbol)
            } header: {
                Label(symbol.title, systemImage: symbol.title)
            }
            .textCase(nil)
        }
        .searchable(text: $searchText, placement: .sidebar)
        .navigationTitle("Symbols")
        .animation(.default, value: searchText)
    }
}

struct InitialDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        InitialDetailsView(symbols: SFCategory.whatsnew.symbols)
    }
}

