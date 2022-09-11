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
    @State private var didReceiveError = false
    @State private var searchText = ""

    private var filteredCatBreeds: [CatBreed] {
        if searchText.isEmpty {
            return viewModel.breeds
        } else {
            return viewModel.breeds.filter { $0.name.contains(searchText) }
        }
    }

    init(viewModel: CatBreedsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            List(filteredCatBreeds) { breed in
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
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .onAppear {
            viewModel.refreshBreeds()
        }
        .onReceive(viewModel.$error, perform: { error in
            if error == nil { return }
            didReceiveError = true
        })
        .alert(isPresented: $didReceiveError) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.error?.localizedDescription ?? "Unknown error"),
                dismissButton: .default(Text("OK")) {
                    didReceiveError = false
                }
            )
        }
    }
}
