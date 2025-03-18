//
//  RecipeViewModelTests.swift
//  RecipeList
//
//  Created by Evan Templeton on 3/12/25.
//

import XCTest
@testable import RecipeList

@MainActor
final class RecipeViewModelTests: XCTestCase {
    
    private var service: RecipeServiceMock!
    private var viewModel: RecipeListViewModel<RecipeServiceMock>!
    
    override func setUp() {
        service = RecipeServiceMock()
        viewModel = RecipeListViewModel(recipeService: service)
    }
    
    func testFetchRecipesSuccess() async {
        await viewModel.fetchRecipes()
        if case .loaded(let recipes) = viewModel.fetchRecipesState {
            XCTAssertEqual(recipes.count, RecipeModel.mocks.count)
        } else {
            XCTFail("Expected loaded state with recipes")
        }
    }
    
    func testFetchRecipesFailure() async {
        service.shouldThrowError = true
        viewModel = RecipeListViewModel(recipeService: service)
        await viewModel.fetchRecipes()
        if case .error(let message) = viewModel.fetchRecipesState {
            XCTAssertTrue(message.contains("Failed to load recipes"))
        } else {
            XCTFail("Expected error state")
        }
    }
}
