//
//  AppTabNavigation.swift
//  SFSymbolsDemo
//
//  Created by Richard Witherspoon on 11/18/21.
//
#if os(iOS)
import SwiftUI
import SFSymbols

struct AppTabNavigation: View {
    @EnvironmentObject var model: ContentViewModel
    @State private var tabSelection = Tab.home
    
    enum Tab {
        case home, categories
    }
    

    var body: some View {
        TabView(selection: $tabSelection) {
            NavigationView{
                InitialDetailsView(symbols: model.symbols)
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("Home", symbol: .house)
                    .accessibility(label: Text("Home"))
            }
            .tag(Tab.home)
            
            
            NavigationView{
                CategoriesList()
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("Categories", symbol: .squareGrid2X2)
                    .accessibility(label: Text("Categories"))
            }
            .tag(Tab.categories)
        }
    }
}


struct AppTabNavigation_Previews: PreviewProvider {
    static var previews: some View {
        AppTabNavigation()
    }
}
#endif
