//
//  ImageCacheTests.swift
//  RecipeList
//
//  Created by Evan Templeton on 3/14/25.
//

import XCTest
@testable import class RecipeList.ImageCache

final class ImageCacheTests: XCTestCase {
    func testImageCaching() {
        let url = URL(string: "https://example.com/test.jpg")!
        let image = UIImage(systemName: "star")!
        ImageCache.shared.set(url, image: image)
        let cachedImage = ImageCache.shared.get(url)
        XCTAssertNotNil(cachedImage)
        XCTAssertEqual(cachedImage, image)
    }
}
