//
//  FailableDecodable.swift
//  RecipeList
//
//  Created by Evan Templeton on 3/13/25.
//

import Foundation

struct FailableDecodable<Base: Decodable>: Decodable {
    
    let base: Base?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.base = try? container.decode(Base.self)
    }
}
