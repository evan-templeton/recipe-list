//
//  ListCellView.swift
//  RecipeList
//
//  Created by Evan Templeton on 3/18/25.
//

import SwiftUI

struct ListCellView: View {
    
    let recipe: RecipeModel
    
    var body: some View {
        HStack {
            Image(uiImage: recipe.image)
                .resizable()
                .scaledToFit()
                .frame(minWidth: 50, maxWidth: 70)
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
}

#Preview {
    let viewModel = RecipeListViewModel(recipeService: RecipeServiceMock())
    RecipeListView(viewModel: viewModel)
}
