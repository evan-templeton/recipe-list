//
//  ImageCache.swift
//  RecipeList
//
//  Created by Evan Templeton on 3/12/25.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSURL, UIImage>()
    
    func get(_ url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }
    
    func set(_ url: URL, image: UIImage) {
        cache.setObject(image, forKey: url as NSURL)
    }
}
