//
//  RecipeViewModel.swift
//  RecipeList
//
//  Created by Evan Templeton on 3/12/25.
//

import Foundation

@MainActor
final class RecipeViewModel<Service: RecipeServiceProtocol>: ObservableObject {
    
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
            let errorMessage = "Failed to load recipes: \(error)"
            fetchRecipesState = .error(errorMessage)
        }
    }
}

extension RecipeViewModel {
    enum FetchRecipesState {
        case loading
        case loaded([Recipe])
        case error(String)
    }
}
