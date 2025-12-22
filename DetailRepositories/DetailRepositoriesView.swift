//
//  DetailRepositoriesView.swift
//  IOS-Code-Challange-SwiftUI
//
//  Created by Ibrahim Alperen Kurum on 22.12.2025.
//

import SwiftUI

struct DetailRepoView: View {
    
    @StateObject private var viewModel: DetailRepoViewModel
    /*
     
     viewModel  --->  DetailRepoViewModel
     _viewModel ---> StateObject<DetailRepoViewModel>
     
     */
    init(repository: Repository) {
        _viewModel = StateObject(
            wrappedValue: DetailRepoViewModel(repository: repository)
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                
                // Description
                Text(viewModel.descriptionText)
                    .font(.system(size: 16, weight: .bold))
                
                TextContainerView(
                    title: viewModel.languageText,
                    imageName: "icon1"
                )
                
                TextContainerView(
                    title: viewModel.forksText,
                    imageName: "icon2"
                )
                
                TextContainerView(
                    title: viewModel.starsText,
                    imageName: "icon3"
                )
                
                TextContainerView(
                    title: viewModel.createdAtText,
                    imageName: "icon4"
                )
                
                Button(action: viewModel.openGithub) {
                    Text("Open in Github")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 24)
                        .background(Color.blue)
                        .cornerRadius(20)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 30)
            }
            .padding()
        }
        .navigationTitle(viewModel.repository.repoName)
        .navigationBarTitleDisplayMode(.automatic)
        .background(Color(.systemBackground))
    }
}

struct TextContainerView: View {
    let title: String
    let imageName: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(imageName)
                .resizable()
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(.system(size: 14))
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.15))
        .cornerRadius(12)
    }
}



#Preview {
    DetailRepoView(repository: Repository(id: 0, repoName: "Repository Name",description: "There si no description There si no description There si no description There si no description There si no description There si no description", forks: 12, stargazersCount: 34, createdAt: "12/12/2025", htmlUrl: "", username: "Username", ownerId: 0, avatarUrl: "", isVisited: false, isFavourite: false))
}
