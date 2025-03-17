//
//  RecipeViewModel.swift
//  RecipeList
//
//  Created by Evan Templeton on 3/12/25.
//

import Foundation
import class UIKit.UIImage

@MainActor
final class RecipeViewModel<Service: RecipeServiceProtocol>: ObservableObject {
    
    @Published var fetchRecipesState: FetchRecipesState = .loading
    private let cache = NSCache<NSURL, UIImage>()
    
    private let recipeService: Service
    
    init(recipeService: Service) {
        self.recipeService = recipeService
    }
    
    func fetchRecipes() async {
        do {
            let recipes = try await recipeService.fetchRecipes()
            fetchRecipesState = .loaded(recipes)
        } catch {
            fetchRecipesState = .error("Failed to load recipes: \(error)")
        }
    }
    
//    func fetchRecipes() async {
//        do {
//            let recipeResponses = try await recipeService.fetchRecipes()
//            let recipes = await withTaskGroup(of: RecipeModel?.self) { group in
//                for recipeResponse in recipeResponses {
//                    group.addTask {
//                        await self.createRecipeModel(from: recipeResponse)
//                    }
//                }
//                
//                var processedRecipes = [RecipeModel]()
//                for await recipeModel in group {
//                    if let recipeModel = recipeModel {
//                        processedRecipes.append(recipeModel)
//                    }
//                }
//                return processedRecipes
//            }
//            fetchRecipesState = .loaded(recipes)
//        } catch {
//            let errorMessage = "Failed to load recipes: \(error)"
//            fetchRecipesState = .error(errorMessage)
//        }
//    }
}

extension RecipeViewModel {
    enum FetchRecipesState {
        case loading
        case loaded([RecipeModel])
        case error(String)
    }
}
