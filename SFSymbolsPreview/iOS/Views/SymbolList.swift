//
//  SymbolList.swift
//  SFSymbolsPreview
//
//  Created by Richard Witherspoon on 11/18/21.
//

import SwiftUI
import SFSymbols


struct SymbolList: View {
    let category: SFCategory
    @State private var searchText = String()
    
    func searchResults()->[SFSymbol]{
        if searchText.isEmpty {
            return category.symbols
        }
        
        return category.symbols.filter({
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.searchTerms?.contains(where: {$0.localizedCaseInsensitiveContains(searchText)}) ?? false
        })
    }
    
    
    var body: some View{
        List(searchResults()){ symbol in
            Label(symbol.title, systemImage: symbol.title)
        }
        .navigationTitle(category.title)
        .animation(.default, value: searchText)
#if os(iOS)
        .searchable(text: $searchText, placement: .navigationBarDrawer)
#elseif os(macOS)
        .searchable(text: $searchText)
#endif
    }
}


struct SymbolList_Previews: PreviewProvider {
    static var previews: some View {
        SymbolList(category: .whatsnew)
    }
}
