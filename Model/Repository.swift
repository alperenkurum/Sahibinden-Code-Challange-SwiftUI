//
//  Repository.swift
//  code-challange
//
//  Created by Ibrahim Alperen Kurum on 27.11.2025.
//

import Foundation

struct Repository: Identifiable, Encodable, Hashable {
    var id: Int
    var repoName: String
    var description: String?
    var forks: Int
    var stargazersCount: Int
    var language: String?
    var createdAt: String
    var htmlUrl: String
    var username: String
    var ownerId: Int
    var avatarUrl: String
    var isVisited: Bool
    var isFavourite: Bool
}


enum Section {
    case main
}

extension Repository {
    init (from detailEntity: RepositoryDetail) {
        self.id = detailEntity.id
        self.repoName = detailEntity.name
        self.description = detailEntity.description
        self.forks = detailEntity.forks
        self.stargazersCount = detailEntity.stargazersCount
        self.createdAt = detailEntity.createdAt
        self.username = detailEntity.owner.login
        self.ownerId = detailEntity.owner.id
        self.avatarUrl = detailEntity.owner.avatarUrl
        self.htmlUrl = detailEntity.htmlUrl
        self.isVisited = false
        self.isFavourite = false
    }
    
    init(from entity: RepositoriesEntity) {
        self.id = Int(entity.repoId ?? "0") ?? 0
        self.repoName = entity.name ?? ""
        self.description = entity.favDescription ?? ""
        self.forks = Int(entity.forks ?? "0") ?? 0
        self.language = entity.language ?? ""
        self.stargazersCount = Int(entity.stargazersCount ?? "0") ?? 0
        self.createdAt = entity.createdAt ?? ""
        self.username = entity.login ?? ""
        self.ownerId = Int(entity.userId ?? "0") ?? 0
        self.avatarUrl = entity.avatarUrl ?? ""
        self.htmlUrl = entity.htmlUrl ?? ""
        self.isVisited = entity.isVisited
        self.isFavourite = entity.isFavourite
    }
}

extension RepositoriesEntity {
    func convert(from repository: Repository) {
        self.repoId = String(repository.id)
        self.name = repository.repoName
        self.favDescription = repository.description
        self.userId = String(repository.id)
        self.login = repository.username
        self.avatarUrl = repository.avatarUrl
        self.forks = String(repository.forks)
        self.language = repository.language
        self.stargazersCount = String(repository.stargazersCount)
        self.createdAt = repository.createdAt
        self.htmlUrl = repository.htmlUrl
        self.isFavourite = repository.isFavourite
        self.isVisited = repository.isVisited
    }
}
