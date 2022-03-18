//
//  CategoriesList.swift
//  SFSymbolsPreview
//
//  Created by Richard Witherspoon on 11/18/21.
//

import SwiftUI
import SFSymbols


struct CategoriesList: View {
    @EnvironmentObject var model: ContentViewModel
    @State private var searchText = String()
    
    
    var searchResults: [SFCategory]{
        if searchText.isEmpty{
            return model.categories
        }
        
        return model.categories.filter{$0.title.localizedCaseInsensitiveContains(searchText)}
    }
    
    
    
    var body: some View {
        List(searchResults){ category in
            NavigationLink(destination: SymbolList(category: category)) {
                Label(.init(category.title), systemImage: category.icon)
            }
        }
        .navigationTitle("Categories")
        .searchable(text: $searchText, placement: .sidebar)        
    }
}

struct CategoriesList_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesList()
    }
}
