//
//  NetworkManager.swift
//  code-challange
//
//  Created by Ibrahim Alperen Kurum on 13.11.2025.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    private let token = Constants.apiKey

    func request<T: Decodable>(_ url: URL) async throws -> NetworkResponse<T> {
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiCallError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw ApiCallError.invalidResponse
        }

        let nextURL = Self.parseNextURL(from: httpResponse)

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let model = try decoder.decode(T.self, from: data)
            return NetworkResponse(model: model, nextURL: nextURL)
        } catch {
            throw ApiCallError.decodingFailed
        }
    }

    private static func parseNextURL(from response: HTTPURLResponse) -> URL? {
        guard let linkHeader = response.value(forHTTPHeaderField: "Link") else { return nil }

        let parts = linkHeader.components(separatedBy: ",")

        for part in parts {
            if part.range(of: "rel=\"next\"") != nil {
                if let start = part.firstIndex(of: "<"),
                   let end = part.firstIndex(of: ">"),
                   start < end
                {
                    let urlString = String(part[part.index(after: start)..<end]).trimmingCharacters(in: .whitespacesAndNewlines)
                    return URL(string: urlString)
                }
            }
        }

        return nil
    }
}

