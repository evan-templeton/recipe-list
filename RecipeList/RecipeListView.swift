//
//  RecipeListView.swift
//  RecipeList
//
//  Created by Evan Templeton on 3/13/25.
//

import SwiftUI

struct RecipeListView<Service: RecipeServiceProtocol>: View {
    
    init(viewModel: RecipeListViewModel<Service>) {
        self.viewModel = viewModel
    }
    
    @ObservedObject private var viewModel: RecipeListViewModel<Service>
    
    var body: some View {
        NavigationStack {
            switch viewModel.fetchRecipesState {
                case .loading: ProgressView()
                case .loaded(let recipes): listView(recipes: recipes)
                case .error(let message): Text(message)
            }
        }
        .task {
            await viewModel.fetchRecipes()
        }
    }
    
    private func listView(recipes: [RecipeModel]) -> some View {
        Group {
            if recipes.isEmpty {
                ErrorView()
            } else {
                List(recipes) { recipe in
                    ListCellView(recipe: recipe)
                }
                .navigationTitle("Recipes")
            }
        }
        .refreshable {
            await viewModel.fetchRecipes()
        }
    }
}

#Preview {
    let viewModel = RecipeListViewModel(recipeService: RecipeServiceMock())
    RecipeListView(viewModel: viewModel)
}
