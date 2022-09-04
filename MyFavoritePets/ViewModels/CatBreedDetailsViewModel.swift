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
    @Published var error: Error?

    init(api: CatApi, breed: CatBreed) {
        self.api = api
        self.breed = breed
    }

    func refreshBreedDetails() {
        Task {
            do {
                DispatchQueue.main.async {
                    self.error = nil
                }
                let breedImages = try await api.fetchBreedImages(breed: breed)
                DispatchQueue.main.async {
                    self.breedImages = breedImages
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error
                }
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
