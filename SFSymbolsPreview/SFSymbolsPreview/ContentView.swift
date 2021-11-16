//
//  ContentView.swift
//  SFSymbolsPreview
//
//  Created by Richard Witherspoon on 11/15/21.
//

import SwiftUI


struct ContentView: View {
    @StateObject var model = ContentViewModel()
    
    var body: some View {
        NavigationView{
            List(model.categories){ category in
                Label(.init(category.title), systemImage: category.icon)
            }
            .navigationTitle("Categories")
            
            List(model.searchResults().suffix(20)){ symbol in
                Section {
                    SymbolRow(symbol: symbol)
                } header: {
                    Label(symbol.title, systemImage: symbol.title)
                }
                .textCase(nil)
            }
            .searchable(text: $model.searchText)
            .navigationTitle("Symbols")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
