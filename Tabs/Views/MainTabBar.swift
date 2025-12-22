//
//  TabBarView.swift
//  IOS-Code-Challange-SwiftUI
//
//  Created by Ibrahim Alperen Kurum on 19.12.2025.
//

import SwiftUI

struct MainTabView: View {
    enum Tab {
        case repositories
        case favourites
    }

    @State private var selectedTab: Tab = .repositories
    @StateObject private var repositoriesViewModel = RepositoriesViewModel()

    var body: some View {
        TabView(selection: $selectedTab) {
            RepositoriesView()
                .tabItem {
                    Label("Repositories", image: "repo")
                }
                .tag(Tab.repositories)

            FavouritesView()
                .tabItem {
                    Label("Favourites", image: "empty")
                }
                .tag(Tab.favourites)
        }
        .environmentObject(repositoriesViewModel)
        .onChange(of: selectedTab) {
            repositoriesViewModel.searchText = ""
        }
    }
}

#Preview {
    MainTabView()
}
