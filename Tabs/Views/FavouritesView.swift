//
//  FavouritesView.swift
//  IOS-Code-Challange-SwiftUI
//
//  Created by Ibrahim Alperen Kurum on 12.12.2025.
//

import SwiftUI

struct FavouritesView: View {
    @EnvironmentObject var repositoriesViewModel: RepositoriesViewModel

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let isLandscape = geo.size.width > geo.size.height
                ScrollView {
                    LazyVGrid(
                        columns: Array(
                            repeating: GridItem(.flexible(), spacing: 6),
                            count: isLandscape ? 2 : 1
                        ),
                        spacing: 6) {
                            ForEach(repositoriesViewModel.getFavouritesRepositories()) { repo in
                            repositoryRow(repo)
                        }
                    }
                        .animation(.easeInOut, value: repositoriesViewModel.getFavouritesRepositories())
                        .padding(12)
                }
            }
            .background(Color.gray.opacity(0.15))
            .navigationTitle("Favourites")
            .navigationDestination(item: $repositoriesViewModel.selectedRepository) { repo in
                DetailRepoView(repository: repo)
            }
        }
    }
    
    private func repositoryRow(_ repo: Repository) -> some View {
        RepositoryCellView(
            repository: repo
        ) {
            withAnimation(.easeInOut) {
                repositoriesViewModel.toggleFavouriteButton(repoId: repo.id)
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(repo.isVisited
                      ? Color.gray.opacity(0.1)
                      : Color.white)
        )
        .contentShape(RoundedRectangle(cornerRadius: 12))
        .onTapGesture {
            repositoriesViewModel.didTappedCellFavourites(id: repo.id)
        }
        .onAppear {
            let lastId = repositoriesViewModel.searchText.isEmpty ? repositoriesViewModel.repositories.last?.id : repositoriesViewModel.filteredRepositories.last?.id
            if repo.id == lastId {
                repositoriesViewModel.fetchMoreRepositories()
            }
        }
    }
}

#Preview {
    //FavouritesView()
}
