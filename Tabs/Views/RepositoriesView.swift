//
//  RepositoriesView.swift
//  IOS-Code-Challange-SwiftUI
//
//  Created by Ibrahim Alperen Kurum on 12.12.2025.
//

import SwiftUI

struct RepositoriesView: View {
    @EnvironmentObject var repositoriesViewModel: RepositoriesViewModel
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let isLandscape = geo.size.width > geo.size.height
                
                VStack (spacing: 8){
                    Picker("Time Range", selection: $repositoriesViewModel.timeRange) {
                        Text(TimeRange.day.rawValue).tag(TimeRange.day)
                        Text(TimeRange.week.rawValue).tag(TimeRange.week)
                        Text(TimeRange.month.rawValue).tag(TimeRange.month)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 12)
                    .padding(.top, 8)
                    .onChange(of: repositoriesViewModel.timeRange) {
                        repositoriesViewModel.didChangedTimeRange()
                    }
                    
                    ScrollView {
                        LazyVGrid(
                            columns: Array(
                                repeating: GridItem(.flexible(), spacing: 6),
                                count: isLandscape ? 2 : 1
                            ),
                            spacing: 6) {
                                ForEach(repositoriesViewModel.searchText.isEmpty ? repositoriesViewModel.repositories : repositoriesViewModel.filteredRepositories) { repo in
                                    repositoryRow(repo)
                                }
                                if repositoriesViewModel.isLoading {
                                    ProgressView()
                                        .padding(.vertical, 24)
                                }
                            }
                            .padding(12)
                    }
                }
                
                .background(Color.gray.opacity(0.15))
                .navigationTitle("Repositories")
                .navigationDestination(item: $repositoriesViewModel.selectedRepository) { repo in
                    DetailRepoView(repository: repo)
                }
                .searchable(text: $repositoriesViewModel.searchText,
                            placement: .navigationBarDrawer(displayMode: .always),
                            prompt: "Search repositories ...")
                .onChange(of: repositoriesViewModel.searchText) {
                    repositoriesViewModel.searchRepositories()
                }
                
            }
        }
        .onAppear {
            repositoriesViewModel.onLoad()
        }
    }
    
    private func repositoryRow(_ repo: Repository) -> some View {
        RepositoryCellView(
            repository: repo
        ) {
            repositoriesViewModel.toggleFavouriteButton(repoId: repo.id)
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
            repositoriesViewModel.didTappedCell(id: repo.id)
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
    //RepositoriesView()
}
