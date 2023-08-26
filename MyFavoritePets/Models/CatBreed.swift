//
//  CatBreed.swift
//  MyFavoritePets
//
//  Created by Andrea Prearo on 8/29/22.
//

import Foundation

struct CatBreed: Codable {
    let id: String
    let name: String
    let description: String
    let temperament: String
    let origin: String
    let referenceImageId: String?
    let weight: CatBreedWeight

    func imageURL() -> String? {
        guard let imageId = referenceImageId else {
            return nil
        }
        return "https://cdn2.thecatapi.com/images/\(imageId).jpg"
    }
}
