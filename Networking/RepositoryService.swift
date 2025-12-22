//
//  RepositoryService.swift
//  code-challange
//
//  Created by Ibrahim Alperen Kurum on 13.11.2025.
//
// BURASI IYI DI=UZENKENECEK
import Foundation

final class RepositoryService {
    private let network = NetworkManager.shared
    private let stateQueue = DispatchQueue(label: "RepositoryService.stateQueue")
    private var nextURL: URL?
    
    func searchRepositories(timeRange: TimeRange, searchText: String) async throws -> NetworkRepository {
        resetPagination()
        let initialURL = try buildInitialURL(range: timeRange, searchText: searchText)
        print(initialURL)
        let data: NetworkRepository = try await fetch(with: initialURL)
        return data
    }
    
    func resetPagination() {
        stateQueue.sync {
            nextURL = nil
        }
    }
    
    func loadNextPage() async throws -> NetworkRepository? {
        guard let next = nextURL else { return nil}
        return try await fetch(with: next)
    }
    
    private func fetch<T: Decodable > (with url: URL) async throws -> T {
        let response: NetworkResponse<T> = try await network.request(url)
        self.nextURL = response.nextURL
        return response.model
    }
}

extension RepositoryService {
    private func buildInitialURL(range: TimeRange, searchText: String) throws -> URL{
        let calender = Calendar.current
        let today = Date()
        let date: Date
        
        switch range {
        case .day:
            date = calender.date(byAdding: .day, value: -1, to: today) ?? today
        case .week:
            date = calender.date(byAdding: .weekOfYear, value: -1, to: today) ?? today
        case .month:
            date = calender.date(byAdding: .month, value: -1, to: today) ?? today
        }
        var components = URLComponents(string: Constants.baseURL)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = formatter.string(from: date)
        let baseQuery = "created:>\(formattedDate)"
        let query = searchText.isEmpty == false ? "\(searchText) \(baseQuery)" : "\(baseQuery)"
        
        components?.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "sort", value: "stars"),
            URLQueryItem(name: "order", value: "desc"),
            URLQueryItem(name: "per_page", value: "20")
        ]
        
        guard let url = components?.url else{
            throw URLError(.badURL)
        }
        
        return url
    }
}

