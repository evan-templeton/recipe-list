//
//  RecipeService.swift
//  RecipeList
//
//  Created by Evan Templeton on 3/12/25.
//

import Foundation
import class UIKit.UIImage

protocol RecipeServiceProtocol {
    func fetchRecipes() async throws -> [RecipeModel]
}

struct RecipeModel {
    let id: UUID
    let name: String
    let cuisine: String
    let image: UIImage
}

struct RecipeService: RecipeServiceProtocol {
    
    private let recipesUrlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    private let malformedUrlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    private let emptyRecipesUrlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    
    func fetchRecipes() async throws -> [RecipeModel] {
        guard let url = URL(string: malformedUrlString) else {
            throw RecipeServiceError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            do {
                let response = try JSONDecoder().decode(RecipesAPIResponse.self, from: data)
                return response.recipes
            } catch {
                throw RecipeServiceError.decodingError(error)
            }
        } catch {
            throw RecipeServiceError.networkError(error)
        }
    }
    
    private func createRecipeModel(from response: RecipeResponse) async -> RecipeModel? {
        if let cachedImage = cache.object(forKey: response.imageUrl as NSURL) {
            return RecipeModel(id: response.id, name: response.name, cuisine: response.cuisine, image: cachedImage)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: response.imageUrl)
            if let uiImage = UIImage(data: data) {
                cache.setObject(uiImage, forKey: response.imageUrl as NSURL)
                return RecipeModel(id: response.id, name: response.name, cuisine: response.cuisine, image: uiImage)
            }
        } catch {
            print("Failed to load image: \(error)")
        }
        
        return nil
    }
}

enum RecipeServiceError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
}

struct RecipeServiceMock: RecipeServiceProtocol {
    var shouldThrowError = false
    
    private static let mockResponse = [
        RecipeResponse(
            id: UUID(),
            cuisine: "Italian",
            name: "Spaghetti",
            imageUrl: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b75ee8ef-a290-4062-8b26-60722d75d09c/small.jpg")!
        ),
        RecipeResponse(
            id: UUID(),
            cuisine: "Japanese",
            name: "Sushi",
            imageUrl: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/658442fe-e3d3-44a5-9081-e2424fb0129d/small.jpg")!
        )
    ]
    
    func fetchRecipes() async throws -> [RecipeModel] {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        return
    }
}
