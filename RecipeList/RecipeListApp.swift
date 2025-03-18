//
//  RecipeListApp.swift
//  RecipeList
//
//  Created by Evan Templeton on 3/12/25.
//

import SwiftUI

@main
struct RecipeListApp: App {
    
    @StateObject private var viewModel = RecipeListViewModel(recipeService: RecipeService())
    
    var body: some Scene {
        WindowGroup {
            RecipeListView(viewModel: viewModel)
        }
    }
}
