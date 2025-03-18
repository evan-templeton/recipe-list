//
//  RecipeListViewModel.swift
//  RecipeList
//
//  Created by Evan Templeton on 3/12/25.
//

import Foundation

@MainActor
final class RecipeListViewModel<Service: RecipeServiceProtocol>: ObservableObject {
    
    @Published var fetchRecipesState: FetchRecipesState = .loading
    
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
}

extension RecipeListViewModel {
    enum FetchRecipesState {
        case loading
        case loaded([RecipeModel])
        case error(String)
    }
}
