//
//  DetailRepoViewModel.swift
//  IOS-Code-Challange-SwiftUI
//
//  Created by Ibrahim Alperen Kurum on 22.12.2025.
//

import Foundation

import Foundation
import SwiftUI

final class DetailRepoViewModel: ObservableObject {
    
    let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    // MARK: - Computed properties (UI-ready)
    
    var descriptionText: String {
        repository.description ?? "No description"
    }
    
    var languageText: String {
        repository.language?.isEmpty == false
        ? repository.language!
        : "Not specified"
    }
    
    var forksText: String {
        String(repository.forks)
    }
    
    var starsText: String {
        String(repository.stargazersCount)
    }
    
    var createdAtText: String {
        formatDate(repository.createdAt)
    }
    
    // MARK: - Actions
    
    func openGithub() {
        guard let url = URL(string: repository.htmlUrl) else { return }
        UIApplication.shared.open(url)
    }
    
    // MARK: - Date formatter
    
    private func formatDate(_ apiDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = formatter.date(from: apiDate) else {
            return "Invalid date"
        }
        
        let calendar = Calendar.current
        let startOfGivenDate = calendar.startOfDay(for: date)
        let startOfToday = calendar.startOfDay(for: Date())
        
        let days = calendar.dateComponents([.day],
                                           from: startOfGivenDate,
                                           to: startOfToday).day ?? 0
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd/MM/yyyy"
        
        return "\(days) days ago at \(displayFormatter.string(from: date))"
    }
}
