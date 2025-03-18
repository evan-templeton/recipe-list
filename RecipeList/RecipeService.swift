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

struct RecipeService: RecipeServiceProtocol {
    
    private let recipesUrlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    private let malformedUrlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    private let emptyRecipesUrlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    
    private let cache: NSCache<NSURL, UIImage>
    private let session: URLSession
    
    init(cache: NSCache<NSURL, UIImage> = NSCache(), session: URLSession = .shared) {
        self.cache = cache
        self.session = session
    }
    
    func fetchRecipes() async throws -> [RecipeModel] {
        guard let url = URL(string: recipesUrlString) else {
            throw RecipeServiceError.invalidURL
        }
        
        let (data, _) = try await session.data(from: url)
        let response = try JSONDecoder().decode(RecipesAPIResponse.self, from: data)
        let models = try await createRecipeModels(response: response)
        return models.sorted { $0.name < $1.name }
    }
    
    private func createRecipeModels(response: RecipesAPIResponse) async throws -> [RecipeModel] {
        try await withThrowingTaskGroup(of: RecipeModel?.self) { group in
            for recipe in response.recipes {
                if let cachedImage = cache.object(forKey: recipe.imageUrl as NSURL) {
                    group.addTask {
                        RecipeModel(id: recipe.id, name: recipe.name, cuisine: recipe.cuisine, image: cachedImage)
                    }
                } else {
                    group.addTask {
                        try await self.createRecipeModel(from: recipe)
                    }
                }
            }
            
            return try await group.reduce(into: [RecipeModel]()) { result, recipeModel in
                if let recipeModel {
                    result.append(recipeModel)
                }
            }
        }
    }
    
    private func createRecipeModel(from response: RecipeResponse) async throws -> RecipeModel {
        let (data, _) = try await session.data(from: response.imageUrl)
        guard let image = UIImage(data: data) else {
            throw RecipeServiceError.decodingError(#function)
        }
        
        cache.setObject(image, forKey: response.imageUrl as NSURL)
        return RecipeModel(id: response.id, name: response.name, cuisine: response.cuisine, image: image)
    }
}

enum RecipeServiceError: Error {
    case invalidURL
    case decodingError(String)
    
    var localizedDescription: String {
        return switch self {
            case .invalidURL: "Invalid URL"
            case .decodingError(let error): "Decoding error: \(error)"
        }
    }
}

struct RecipeServiceMock: RecipeServiceProtocol {
    var shouldThrowError = false
    
    func fetchRecipes() async throws -> [RecipeModel] {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        return RecipeModel.mocks
    }
}
