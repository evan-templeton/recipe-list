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

struct RecipeModel: Identifiable {
    let id: UUID
    let name: String
    let cuisine: String
    let image: UIImage
}

struct RecipeService: RecipeServiceProtocol {
    
    private let recipesUrlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    private let malformedUrlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    private let emptyRecipesUrlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    
    private let cache = NSCache<NSURL, UIImage>()
    
    func fetchRecipes() async throws -> [RecipeModel] {
        guard let url = URL(string: recipesUrlString) else {
            throw RecipeServiceError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            do {
                let response = try JSONDecoder().decode(RecipesAPIResponse.self, from: data)
                
                return await withTaskGroup(of: RecipeModel?.self) { group in
                    for recipe in response.recipes {
                        group.addTask {
                            await self.createRecipeModel(from: recipe)
                        }
                    }
                    
                    var recipes = [RecipeModel]()
                    for await recipeModel in group {
                        if let recipeModel = recipeModel {
                            recipes.append(recipeModel)
                        }
                    }
                    return recipes
                }
            } catch {
                throw RecipeServiceError.decodingError(error)
            }
        } catch {
            throw RecipeServiceError.networkError(error)
        }
    }
    
//    func fetchRecipes() async throws -> [RecipeModel] {
//        guard let url = URL(string: malformedUrlString) else {
//            throw RecipeServiceError.invalidURL
//        }
//        
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            do {
//                let response = try JSONDecoder().decode(RecipesAPIResponse.self, from: data)
//                return response.recipes
//            } catch {
//                throw RecipeServiceError.decodingError(error)
//            }
//        } catch {
//            throw RecipeServiceError.networkError(error)
//        }
//    }
    
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
    
    private let mockRecipes = [
        RecipeModel(id: UUID(), name: "Spaghetti", cuisine: "Italian", image: UIImage(systemName: "fork.knife")!),
        RecipeModel(id: UUID(), name: "Sushi", cuisine: "Japanese", image: UIImage(systemName: "fish")!)
    ]
    
    func fetchRecipes() async throws -> [RecipeModel] {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        return mockRecipes
    }
}
