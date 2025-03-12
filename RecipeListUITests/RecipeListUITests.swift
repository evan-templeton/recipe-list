//
//  RecipeListUITests.swift
//  RecipeListUITests
//
//  Created by Evan Templeton on 3/12/25.
//

import XCTest

final class RecipeListUITests: XCTestCase {
    func testRecipeListDisplaysMockData() {
        let app = XCUIApplication()
        app.launchArguments = ["-UITest"]
        app.launch()
        
        let firstRecipe = app.staticTexts["Spaghetti"]
        let secondRecipe = app.staticTexts["Sushi"]
        
        XCTAssertTrue(firstRecipe.exists)
        XCTAssertTrue(secondRecipe.exists)
    }
}
