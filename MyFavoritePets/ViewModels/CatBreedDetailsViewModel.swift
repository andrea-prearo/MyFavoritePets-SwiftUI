//
//  CatBreedDetailsViewModel.swift
//  MyFavoritePets
//
//  Created by Andrea Prearo on 9/2/22.
//

import Foundation

class CatBreedDetailsViewModel: ObservableObject {
    private let api: CatApi
    let breed: CatBreed

    @Published var breedImages = [CatBreedImage]()

    init(api: CatApi, breed: CatBreed) {
        self.api = api
        self.breed = breed
    }

    func refreshBreedDetails() {
        Task {
            do {
                let breedImages = try await api.fetchBreedImages(breed: breed)
                DispatchQueue.main.async {
                    self.breedImages = breedImages
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func formattedWeight() -> String {
        let start = "Weight"
        if (Locale.current.usesMetricSystem) {
            return "\(start): \(breed.weight.metric) \(UnitMass.kilograms.symbol)"
        }
        return "\(start): \(breed.weight.imperial) \(UnitMass.pounds.symbol)"
    }
}
