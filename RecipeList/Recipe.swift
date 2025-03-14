//
//  Recipe.swift
//  RecipeList
//
//  Created by Evan Templeton on 3/12/25.
//

import Foundation

struct RecipeResponse: Identifiable, Decodable {
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

struct RecipesAPIResponse: Decodable {
    let recipes: [RecipeResponse]
    
    enum CodingKeys: String, CodingKey {
        case recipes
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let values = try container.decode([FailableDecodable<RecipeResponse>].self, forKey: .recipes)
        recipes = values.compactMap(\.base)
    }
}
