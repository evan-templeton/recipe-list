//
//  RecipeListView.swift
//  RecipeList
//
//  Created by Evan Templeton on 3/13/25.
//

import SwiftUI

struct RecipeListView<Service: RecipeServiceProtocol>: View {
    
    init(service: Service) {
        _viewModel = StateObject(wrappedValue: RecipeViewModel(recipeService: service))
    }
    
    @StateObject private var viewModel: RecipeViewModel<Service>
    
    var body: some View {
        NavigationView {
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
    
    private func listView(recipes: [Recipe]) -> some View {
        Group {
            if recipes.isEmpty {
                errorView()
            } else {
                List(recipes) { recipe in
                    HStack {
                        AsyncImageView(url: recipe.image)
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        VStack(alignment: .leading) {
                            Text(recipe.name)
                                .font(.headline)
                            Text(recipe.cuisine)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .navigationTitle("Recipes")
            }
        }
        .refreshable {
            await viewModel.fetchRecipes()
        }
    }
    
    private func errorView() -> some View {
        VStack {
            ZStack {
                Image(systemName: "line.diagonal")
                    .font(.system(size: 120))
                Image(systemName: "fork.knife")
                    .font(.system(size: 90))
                    .opacity(0.8)
            }
            .foregroundStyle(.gray)
            Text("Your server's on break.")
                .font(.largeTitle)
                .bold()
            Text("He'll be back in a minute. Sorry for the delay.")
                .font(.body)
                .foregroundStyle(.gray)
        }
        .multilineTextAlignment(.center)
    }
}

#Preview {
    RecipeListView(service: RecipeServiceMock())
}
