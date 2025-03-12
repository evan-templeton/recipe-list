//
//  RecipeViewModelTests.swift
//  RecipeList
//
//  Created by Evan Templeton on 3/12/25.
//

import XCTest
@testable import RecipeList

@MainActor
class RecipeViewModelTests: XCTestCase {
    func testFetchRecipesSuccess() async {
        let mockService = MockRecipeService()
        let viewModel = RecipeViewModel(recipeService: mockService)
        
        await viewModel.fetchRecipes()
        
        XCTAssertEqual(viewModel.recipes.count, 2)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testFetchRecipesFailure() async {
        let mockService = MockRecipeService()
        mockService.shouldThrowError = true
        let viewModel = RecipeViewModel(recipeService: mockService)
        
        await viewModel.fetchRecipes()
        
        XCTAssertEqual(viewModel.recipes.count, 0)
        XCTAssertEqual(viewModel.errorMessage, "Failed to load recipes")
    }
}
