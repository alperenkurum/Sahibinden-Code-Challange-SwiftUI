//
//  Repository.swift
//  code-challange
//
//  Created by Ibrahim Alperen Kurum on 12.11.2025.
//

import Foundation

struct NetworkRepository: Decodable, Hashable {
    var totalCount: Int
    var items: [RepositoryDetail]
}
struct RepositoryDetail: Decodable, Hashable, Identifiable {
    var id: Int
    var name: String //repo name
    var description: String?
    var owner: Owner
    var forks: Int
    var stargazersCount: Int
    var language: String?
    var createdAt: String
    var htmlUrl: String
}

struct Owner: Decodable, Hashable {
    var login: String //username
    var id: Int
    var avatarUrl: String
    
}
