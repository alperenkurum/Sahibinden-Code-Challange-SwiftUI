//
//  CachedImageLoader.swift
//  IOS-Code-Challange-SwiftUI
//
//  Created by Ibrahim Alperen Kurum on 18.12.2025.
//

import SwiftUI

@MainActor
final class CachedImageLoader: ObservableObject {
    @Published var image: UIImage?

    private let url: URL

    init(url: URL) {
        self.url = url
    }

    func load() async {
        let request = URLRequest(
            url: url,
            cachePolicy: .returnCacheDataElseLoad
        )

        // ✅ Try cache first
        if let cached = URLCache.shared.cachedResponse(for: request),
           let image = UIImage(data: cached.data) {
            self.image = image
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            let cachedResponse = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cachedResponse, for: request)
            self.image = UIImage(data: data)
        } catch {
            print("Image load failed:", error)
        }
    }
}
