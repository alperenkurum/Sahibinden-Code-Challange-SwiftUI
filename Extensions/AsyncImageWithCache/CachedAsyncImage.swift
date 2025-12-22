//
//  CachedAsyncImage.swift
//  IOS-Code-Challange-SwiftUI
//
//  Created by Ibrahim Alperen Kurum on 18.12.2025.
//

import SwiftUI

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    @StateObject private var loader: CachedImageLoader

    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder

    init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        guard let url else {
            _loader = StateObject(wrappedValue: CachedImageLoader(url: URL(string: "about:blank")!))
            self.content = content
            self.placeholder = placeholder
            return
        }

        _loader = StateObject(wrappedValue: CachedImageLoader(url: url))
        self.content = content
        self.placeholder = placeholder
    }

    var body: some View {
        Group {
            if let uiImage = loader.image {
                content(Image(uiImage: uiImage))
            } else {
                placeholder()
            }
        }
        .task {
            await loader.load()
        }
    }
}
