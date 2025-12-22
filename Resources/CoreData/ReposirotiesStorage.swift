//
//  FavouriteReposirotiesStorage.swift
//  code-challange
//
//  Created by Ibrahim Alperen Kurum on 19.11.2025.
//

import Foundation

final class ReposirotiesStorage {
    func saveRepository(repository: Repository) {
        let model = DataManagerModel(id: String(repository.id),
                                     repoName: repository.repoName,
                                     favDescription: repository.description ?? "",
                                     login: repository.username,
                                     userId: String(repository.id),
                                     avatarUrl: repository.avatarUrl,
                                     createdAt: repository.createdAt,
                                     language: repository.language ?? "",
                                     stargazersCount: String(repository.stargazersCount),
                                     forks: String(repository.forks),
                                     htmlUrl: repository.htmlUrl,
                                     isFavourite: repository.isFavourite,
                                     isVisited: repository.isVisited)
        let _ = DataManager.shared.repository(model: model)
        DataManager.shared.saveContext()
    }
    
    func deleteRepository(repoId: String) {
        if let repository = DataManager.shared.findRepository(id: repoId){
            let context = DataManager.shared.persistentContainer.viewContext
            context.delete(repository)
            DataManager.shared.saveContext()
        }
    }
    
    func isFavourite(repoId: String) -> Bool {
        guard let repository = DataManager.shared.findRepository(id: repoId) else {
            return false
        }
        return repository.isFavourite
    }
    
    func isVisited(repoId: String) -> Bool {
        guard let repository = DataManager.shared.findRepository(id: repoId) else {
            return false
        }
        return repository.isVisited
    }
    
    func setIsVisited(repoId: String) {
        guard let repository = DataManager.shared.findRepository(id: repoId) else { return }
        repository.isVisited = true
        if checkFavouriteVisitedState(repository: repository) == false {
            deleteRepository(repoId: repoId)
        }
        DataManager.shared.saveContext()
    }
    
    func toggleIsFavourite(repoId: String) {
        guard let repository = DataManager.shared.findRepository(id: repoId) else { return }
        repository.isFavourite.toggle()
        if checkFavouriteVisitedState(repository: repository) == false {
            deleteRepository(repoId: repoId)
        }
        DataManager.shared.saveContext()
    }
    
    func isExist(repoId: String) -> Bool {
        guard let _ = DataManager.shared.findRepository(id: repoId) else { return false }
        return true
    }
    
    func fetchFavourites() -> [Repository] {
        let repositoriesEntity = DataManager.shared.repositories()
        let repositories = repositoriesEntity
            .filter { $0.isFavourite }
            .map { Repository(from: $0) }
        return repositories
    }
    
    private func checkFavouriteVisitedState(repository: RepositoriesEntity) -> Bool {
        return repository.isFavourite || repository.isVisited
    }
}
