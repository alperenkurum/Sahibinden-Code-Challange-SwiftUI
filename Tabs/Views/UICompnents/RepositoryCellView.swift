//
//  RepositoryCellView.swift
//  IOS-Code-Challange-SwiftUI
//
//  Created by Ibrahim Alperen Kurum on 12.12.2025.
//

import SwiftUI

struct RepositoryCellView: View {
    var repository: Repository
    var onToggleFavourite: () -> Void
    var body: some View {
        HStack {
            CachedAsyncImage(url: URL(string: repository.avatarUrl),
                       content: { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .cornerRadius(25)
                    .padding(.trailing, 10)
            }, placeholder: {
                ProgressView()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .padding(.trailing, 10)
            })
            
            VStack(alignment: .leading) {
                Text(repository.repoName)
                    .font(.headline)
                    .lineLimit(1)
                Text(repository.description == nil || repository.description!.isEmpty ? "No description" : repository.description!)
                    .font(.caption)
                    .fontWeight(.light)
                    .lineLimit(2)
            }
            Spacer()
            HStack {
                Image(repository.isFavourite ? "filled": "empty")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.leading, 5)
                    .onTapGesture {
                        onToggleFavourite()
                    }
                Image(systemName: "chevron.right")
                    .frame(width: 20, height: 20)
            }
        }
    }
}

#Preview {
    RepositoryCellView(
        repository: Repository(id: 0, repoName: "Repository Name",description: "There si no description There si no description There si no description There si no description There si no description There si no description", forks: 12, stargazersCount: 34, createdAt: "12/12/2025", htmlUrl: "", username: "Username", ownerId: 0, avatarUrl: "", isVisited: false, isFavourite: false),
        onToggleFavourite: {}
    )
}
