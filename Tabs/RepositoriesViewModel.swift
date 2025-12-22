//
//  RepositoriesViewModel.swift
//  IOS-Code-Challange-SwiftUI
//
//  Created by Ibrahim Alperen Kurum on 12.12.2025.
//

import Foundation

@MainActor
final class RepositoriesViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    @Published var filteredRepositories: [Repository] = []
    @Published var searchText: String = ""
    @Published var timeRange: TimeRange = .day
    @Published var isLoading: Bool = false
    @Published var selectedRepository: Repository?
    private var fetchingTask: Task<Void, Never>?
    private let service = RepositoryService()
    private let storageCoreData = ReposirotiesStorage()
    //private let storageCoreData = ReposirotiesStorage()
    
    func searchRepositories() {
        isLoading = true
        fetchInitialRepositories()
    }
    
    func onLoad() {
        isLoading = true
        fetchInitialRepositories()
        
    }
    
    func fetchMoreRepositories() {
        if isLoading == false {
            isLoading = true
            fetchNextRepositories()
        }
    }

    func didTappedCell(id: Int) {
        if let index = searchText.isEmpty ? repositories.firstIndex(where: { $0.id == id }) : filteredRepositories.firstIndex(where: { $0.id == id }) {
            if searchText.isEmpty {
                repositories[index].isVisited = true
            } else {
                filteredRepositories[index].isVisited = true
            }
            if storageCoreData.isExist(repoId: String(id)) {
                storageCoreData.setIsVisited(repoId: String(id))
            } else {
                storageCoreData.saveRepository(repository: repositories[index])
            }
            selectedRepository = repositories[index]
        }
    }
    
    func toggleFavouriteButton(repoId: Int) {
        if let index = searchText.isEmpty ? repositories.firstIndex(where: { $0.id == repoId }) : filteredRepositories.firstIndex(where: { $0.id == repoId }) {
            searchText.isEmpty ? repositories[index].isFavourite.toggle() : filteredRepositories[index].isFavourite.toggle()
            if storageCoreData.isExist(repoId: String(repoId)) {
                storageCoreData.toggleIsFavourite(repoId: String(repoId))
            } else {
                storageCoreData.saveRepository(repository: repositories[index])
            }
        }
    }
    
    func getFavouritesRepositories() -> [Repository] {
        return storageCoreData.fetchFavourites()        
    }
    
    func didChangedTimeRange() {
        isLoading = true
        searchText.isEmpty ? repositories.removeAll() : filteredRepositories.removeAll()
        fetchInitialRepositories()
    }
}

//Interactor
private extension RepositoriesViewModel {
    func fetchInitialRepositories() {
        cancelFetchingTask()
        fetchingTask = Task {
            do {
                let networkRepo = try await service.searchRepositories(timeRange: timeRange, searchText: searchText)
                searchText.isEmpty ? fetchRepositoriesDidSuccess(repositoriesDetail: networkRepo.items) : fetchSearchRepositoriesDidSuccess(repositoriesDetail: networkRepo.items)
            } catch {
                fetchRepositoriesDidFail(error: error)
            }
        }
    }
    
    func fetchNextRepositories() {
        Task {
            do {
                if let networkRepo = try await service.loadNextPage() {
                    fetchNextPageRepositoriesDidSuccess(repositoriesDetail: networkRepo.items)
                }
            } catch {
                fetchRepositoriesDidFail(error: error)
            }
        }
    }
    
    func cancelFetchingTask() {
        fetchingTask?.cancel()
        print("task cancelled")
        fetchingTask = nil
    }
}

private extension RepositoriesViewModel {
    func fetchRepositoriesDidSuccess(repositoriesDetail: [RepositoryDetail]) {
        let tmpRepositories = repositoriesDetail.map({Repository(from: $0)})
        let updatedRepositories = tmpRepositories.map { repo in
            var updatedRepo = repo
            updatedRepo.isVisited = storageCoreData.isVisited(repoId: String(repo.id))
            updatedRepo.isFavourite = storageCoreData.isFavourite(repoId: String(repo.id))
            return updatedRepo
        }
        DispatchQueue.main.async {
            self.searchText.isEmpty ? self.repositories.removeAll() : self.filteredRepositories.removeAll()
            self.repositories.append(contentsOf: updatedRepositories)
            self.isLoading = false
        }
        
    }
    
    func fetchNextPageRepositoriesDidSuccess(repositoriesDetail: [RepositoryDetail]) {
        let tmpRepositories = repositoriesDetail.map({Repository(from: $0)})
        let updatedRepositories = tmpRepositories.map { repo in
            var updatedRepo = repo
            updatedRepo.isVisited = storageCoreData.isVisited(repoId: String(repo.id))
            updatedRepo.isFavourite = storageCoreData.isFavourite(repoId: String(repo.id))
            return updatedRepo
        }
        DispatchQueue.main.async {
            self.searchText.isEmpty ? self.repositories.append(contentsOf: updatedRepositories) : self.filteredRepositories.append(contentsOf: updatedRepositories)
            self.isLoading = false
        }
        
    }

    
    func fetchSearchRepositoriesDidSuccess(repositoriesDetail: [RepositoryDetail]) {
        let tmpRepositories = repositoriesDetail.map({Repository(from: $0)})
        let updatedRepositories = tmpRepositories.map { repo in
            var updatedRepo = repo
            updatedRepo.isVisited = storageCoreData.isVisited(repoId: String(repo.id))
            updatedRepo.isFavourite = storageCoreData.isFavourite(repoId: String(repo.id))
            return updatedRepo
        }
        DispatchQueue.main.async {
            self.filteredRepositories = updatedRepositories
            self.isLoading = false
        }
        
    }

    
    func fetchRepositoriesDidFail(error: Error) {
        DispatchQueue.main.async {
            self.isLoading = false
        }
        print(error.localizedDescription)
        
    }
    
}
