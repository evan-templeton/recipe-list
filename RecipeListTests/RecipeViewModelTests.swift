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
    private var viewModel: RecipeViewModel<RecipeServiceMock>!
    
    override func setUp() {
        service = RecipeServiceMock()
        viewModel = RecipeViewModel(recipeService: service)
    }
    
    func testFetchRecipesSuccess() async {
        await viewModel.fetchRecipes()
        if case .loaded(let recipes) = viewModel.fetchRecipesState {
            XCTAssertEqual(recipes.count, 2)
        } else {
            XCTFail("Expected loaded state with recipes")
        }
    }
    
    func testFetchRecipesFailure() async {
        service.shouldThrowError = true
        viewModel = RecipeViewModel(recipeService: service)
        await viewModel.fetchRecipes()
        if case .error(let message) = viewModel.fetchRecipesState {
            XCTAssertTrue(message.contains("Failed to load recipes"))
        } else {
            XCTFail("Expected error state")
        }
    }
    
//    func testImageCaching() {
//        let url = URL(string: "https://example.com/test.jpg")!
//        let image = UIImage(systemName: "star")!
//        ImageCache.shared.set(url, image: image)
//        let cachedImage = ImageCache.shared.get(url)
//        XCTAssertNotNil(cachedImage)
//        XCTAssertEqual(cachedImage, image)
//    }
}
