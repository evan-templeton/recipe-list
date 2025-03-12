//
//  Recipe.swift
//  RecipeList
//
//  Created by Evan Templeton on 3/12/25.
//

import Foundation

struct Recipe: Identifiable, Decodable {
    let id: UUID
    let cuisine: String
    let name: String
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case image = "photo_url_small"
        case id = "uuid"
    }
}
