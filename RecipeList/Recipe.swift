//
//  Recipe.swift
//  RecipeList
//
//  Created by Evan Templeton on 3/12/25.
//

import Foundation
import class UIKit.UIImage

struct RecipeModel: Identifiable {
    let id: UUID
    let name: String
    let cuisine: String
    let image: UIImage
}

extension RecipeModel {
    static let mocks = [
        RecipeModel(id: UUID(), name: "Pizza", cuisine: "Italian", image: .pizza),
        RecipeModel(id: UUID(), name: "Pizza Again", cuisine: "Italian", image: .pizza)
    ]
}

struct RecipeResponse: Identifiable, Codable {
    let id: UUID
    let cuisine: String
    let name: String
    let imageUrl: URL
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case cuisine
        case name
        case imageUrl = "photo_url_small"
    }
}

struct RecipesAPIResponse: Codable {
    let recipes: [RecipeResponse]
    
    enum CodingKeys: String, CodingKey {
        case recipes
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let values = try container.decode([FailableDecodable<RecipeResponse>].self, forKey: .recipes)
        recipes = values.compactMap(\.base)
    }
    
    init(recipes: [RecipeResponse]) {
        self.recipes = recipes
    }
}
