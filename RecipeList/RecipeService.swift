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

private struct RecipesResponse: Decodable {
    let recipes: [Recipe]
}

struct RecipeService: RecipeServiceProtocol {
    func fetchRecipes() async throws -> [Recipe] {
        guard let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") else {
            throw RecipeServiceError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            do {
                print(String(decoding: data, as: UTF8.self))
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

class MockRecipeService: RecipeServiceProtocol {
    var shouldThrowError = false
    
    func fetchRecipes() async throws -> [Recipe] {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        return [
            Recipe(id: UUID(), cuisine: "Italian", name: "Spaghetti", image: "https://example.com/spaghetti.jpg"),
            Recipe(id: UUID(), cuisine: "Japanese", name: "Sushi", image: "https://example.com/sushi.jpg")
        ]
    }
}
