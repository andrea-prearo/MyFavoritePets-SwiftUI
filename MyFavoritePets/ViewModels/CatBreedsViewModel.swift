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

    init(api: CatApi) {
        self.api = api

        refreshBreeds()
    }

    func refreshBreeds() {
        api.fetchBreeds { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .failure(let error):
                    // TODO
                    break
                case .success(let breeds):
                    self.breeds = breeds
            }
        }
    }
}
