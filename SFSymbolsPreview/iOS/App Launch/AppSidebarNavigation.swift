//
//  AppSidebarNavigation.swift
//  SFSymbolsPreview
//
//  Created by Richard Witherspoon on 11/18/21.
//

import SwiftUI

struct AppSidebarNavigation: View {
    @EnvironmentObject var model: ContentViewModel

    var body: some View {
        NavigationView{
            CategoriesList()
            InitialDetailsView(symbols: model.symbols)
        }
    }
}

struct AppSidebarNavigation_Previews: PreviewProvider {
    static var previews: some View {
        AppSidebarNavigation()
    }
}
