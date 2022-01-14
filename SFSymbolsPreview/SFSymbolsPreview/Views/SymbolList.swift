//
//  SymbolList.swift
//  SFSymbolsPreview
//
//  Created by Richard Witherspoon on 11/18/21.
//

import SwiftUI
import SFSymbols


struct SymbolList: View{
    let category: SFCategory

    init(category: SFCategory) {
        self.category = SFCategory.allCategories.first(where: {$0.plistTitle == category.title})!
    }
    
    
    var body: some View{
        List(category.symbols){ symbol in
            Label(symbol.title, systemImage: symbol.title)
        }
        .navigationTitle(category.title)
    }
}


struct SymbolList_Previews: PreviewProvider {
    static var previews: some View {
        SymbolList(category: .whatsnew)
    }
}
