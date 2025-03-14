//
//  AsyncImageView.swift
//  RecipeList
//
//  Created by Evan Templeton on 3/12/25.
//

import SwiftUI

struct AsyncImageView: View {
    let url: String
    @State private var image: UIImage? = nil
    
    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .task {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        guard let url = URL(string: url) else { return }
        
        if let cachedImage = ImageCache.shared.get(url) {
            image = cachedImage
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                image = uiImage
                ImageCache.shared.set(url, image: uiImage)
            }
        } catch {
            print("Failed to load image: \(error)")
        }
    }
}
