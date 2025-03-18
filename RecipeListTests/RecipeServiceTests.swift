//
//  RecipeServiceTests.swift
//  RecipeList
//
//  Created by Evan Templeton on 3/18/25.
//

import XCTest
@testable import RecipeList

class RecipeServiceTests: XCTestCase {
    
    private var cache: NSCache<NSURL, UIImage>!
    private var session: URLSession!
    private var recipeService: RecipeService!

    override func setUp() {
        super.setUp()
        cache = NSCache<NSURL, UIImage>()
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        session = URLSession(configuration: config)
        
        recipeService = RecipeService(cache: cache, session: session)
    }

    override func tearDown() {
        URLProtocolMock.requestHandler = nil
        super.tearDown()
    }

    func testCaching_ShouldUseCachedImage_WhenImageAlreadyExists() async throws {
        
        let imageUrl = URL(string: "https://example.com/image.jpg")!
        let cachedImage = UIImage.pizza
        cache.setObject(cachedImage, forKey: imageUrl as NSURL)
        
        let mockResponse = RecipesAPIResponse(recipes: [
            RecipeResponse(id: UUID(), cuisine: "Test", name: "Test Recipe", imageUrl: imageUrl)
        ])
        
        URLProtocolMock.requestHandler = { request in
            let data = try JSONEncoder().encode(mockResponse)
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        let recipes = try await recipeService.fetchRecipes()
        
        XCTAssertEqual(recipes.count, 1)
        XCTAssertEqual(recipes.first!.image, cachedImage)
    }

    func testCaching_ShouldDownloadAndCacheImage_WhenImageNotCached() async throws {
        
        let imageUrl = URL(string: "https://example.com/image.jpg")!
        let imageData = UIImage.pizza.pngData()!
        
        let mockResponse = RecipesAPIResponse(recipes: [
            RecipeResponse(id: UUID(), cuisine: "Test", name: "Test Recipe", imageUrl: imageUrl)
        ])
        
        URLProtocolMock.requestHandler = { request in
            if request.url == imageUrl {
                let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                return (response, imageData)
            }
            
            let data = try JSONEncoder().encode(mockResponse)
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        let recipes = try await recipeService.fetchRecipes()
        
        XCTAssertEqual(recipes.count, 1)
        XCTAssertEqual(cache.object(forKey: imageUrl as NSURL)?.pngData(), imageData)
    }
}
