//
//  CatBreedsViewModel.swift
//  MyFavoritePets
//
//  Created by Andrea Prearo on 9/2/22.
//

import Foundation

class CatBreedsViewModel: ObservableObject {
    private let api: CatApi

    @Published var breeds = [CatBreed]()
    @Published var error: Error?

    init(api: CatApi) {
        self.api = api
    }

    func refreshBreeds() {
        Task {
            do {
                DispatchQueue.main.async {
                    self.error = nil
                }
                let breeds = try await api.fetchBreeds()
                DispatchQueue.main.async {
                    self.breeds = breeds
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error
                }
            }
        }
    }
}
