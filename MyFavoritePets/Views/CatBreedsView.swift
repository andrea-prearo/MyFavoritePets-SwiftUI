//
//  CatBreedsView.swift
//  MyFavoritePets
//
//  Created by Andrea Prearo on 8/29/22.
//

import SwiftUI

extension CatBreed: Identifiable {}

struct CatBreedsView: View {
    @ObservedObject private var viewModel: CatBreedsViewModel

    init(viewModel: CatBreedsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            List(viewModel.breeds) { breed in
                ZStack(alignment: .leading) {
                    CatBreedRow(breed: breed)
                    NavigationLink(
                        destination: CatBreedDetailsView(
                            viewModel: CatBreedDetailsViewModel(
                                api: CatApi.shared,
                                breed: breed)
                        )
                    ) {
                        EmptyView()
                    }.opacity(0)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Cat Breeds")
        }
        .onAppear {
            viewModel.refreshBreeds()
        }
    }
}
