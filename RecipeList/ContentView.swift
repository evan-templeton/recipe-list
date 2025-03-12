//
//  ContentView.swift
//  RecipeList
//
//  Created by Evan Templeton on 3/12/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        RecipeListView(viewModel: RecipeViewModel(recipeService: RecipeService()))
    }
}

struct RecipeListView: View {
    @StateObject var viewModel: RecipeViewModel<RecipeService>
    
    var body: some View {
        NavigationView {
            switch viewModel.fetchRecipesState {
                case .loading:
                    ProgressView()
                case .loaded(let recipes):
                    List(recipes) { recipe in
                        HStack {
                            AsyncImageView(url: recipe.image)
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            VStack(alignment: .leading) {
                                Text(recipe.name).font(.headline)
                                Text(recipe.cuisine).font(.subheadline).foregroundColor(.gray)
                            }
                        }
                    }
                    .navigationTitle("Recipes")
                    .refreshable {
                        await viewModel.fetchRecipes()
                    }
                case .error(let errorMessage):
                    Text(errorMessage)
            }
        }
        .task {
            await viewModel.fetchRecipes()
        }
    }
}

#Preview {
    ContentView()
}
