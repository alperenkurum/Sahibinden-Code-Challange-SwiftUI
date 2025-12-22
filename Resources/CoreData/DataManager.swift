//
//  DataManager.swift
//  code-challange
//
//  Created by Ibrahim Alperen Kurum on 19.11.2025.
//

import Foundation
import CoreData

struct DataManagerModel {
    let id: String
    let repoName: String
    let favDescription: String
    let login: String
    let userId: String
    let avatarUrl: String
    let createdAt: String
    let language: String
    let stargazersCount: String
    let forks: String
    let htmlUrl: String
    let isFavourite: Bool
    let isVisited: Bool
}


class DataManager {
    static let shared = DataManager()
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "AppDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func repositories() -> [RepositoriesEntity] {
        let request: NSFetchRequest<RepositoriesEntity> = RepositoriesEntity.fetchRequest()
        do {
            return try persistentContainer.viewContext.fetch(request)
        } catch {
            fatalError("Failed to fetch notes: \(error)")
        }
    }
    
    func findRepository(id: String) -> RepositoriesEntity? {
        let request: NSFetchRequest<RepositoriesEntity> = RepositoriesEntity.fetchRequest()
        request.predicate = NSPredicate(format: "repoId == %@", id)
        do {
            let repositories = try persistentContainer.viewContext.fetch(request)
            return repositories.first
        } catch {
            print(error)
            return nil
        }
    }
    
    @discardableResult
    func repository(model: DataManagerModel) -> RepositoriesEntity {
        let repo = RepositoriesEntity(context: persistentContainer.viewContext)
        repo.repoId = model.id
        repo.name = model.repoName
        repo.favDescription = model.favDescription
        repo.login = model.login
        repo.userId = model.userId
        repo.avatarUrl = model.avatarUrl
        repo.forks = model.forks
        repo.language = model.language
        repo.stargazersCount = model.stargazersCount
        repo.createdAt = model.createdAt
        repo.htmlUrl = model.htmlUrl
        repo.isFavourite = model.isFavourite
        repo.isVisited = model.isVisited
        return repo
    }
    
    func clearVisitedRepositories() {
        let repositories = repositories()
        
        for repository in repositories {
            repository.isVisited = false
        }
        saveContext()
    }
    
    func clearRepositories() {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RepositoriesEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
            print("RepositoriesEntity cleared.")
        } catch {
            print("Failed to clear repositories: \(error)")
        }
    }

}

