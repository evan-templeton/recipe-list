//
//  RecipeService.swift
//  RecipeList
//
//  Created by Evan Templeton on 3/12/25.
//

import Foundation

protocol RecipeServiceProtocol {
    func fetchRecipes() async throws -> [Recipe]
}

struct RecipeService: RecipeServiceProtocol {
    
    private let recipesUrlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    private let malformedUrlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    private let emptyRecipesUrlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    
    func fetchRecipes() async throws -> [Recipe] {
        guard let url = URL(string: malformedUrlString) else {
            throw RecipeServiceError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            do {
                let response = try JSONDecoder().decode(RecipesResponse.self, from: data)
                return response.recipes
            } catch {
                throw RecipeServiceError.decodingError(error)
            }
        } catch {
            throw RecipeServiceError.networkError(error)
        }
    }
}

enum RecipeServiceError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
}

struct RecipeServiceMock: RecipeServiceProtocol {
    var shouldThrowError = false
    
    func fetchRecipes() async throws -> [Recipe] {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        return [
            Recipe(
                id: UUID(),
                cuisine: "Italian",
                name: "Spaghetti",
                image: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b75ee8ef-a290-4062-8b26-60722d75d09c/small.jpg"
            ),
            Recipe(
                id: UUID(),
                cuisine: "Japanese",
                name: "Sushi",
                image: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/658442fe-e3d3-44a5-9081-e2424fb0129d/small.jpg"
            )
        ]
    }
}
