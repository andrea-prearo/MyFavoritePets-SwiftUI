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
    @State private var isLoading = false

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
            ZStack {
                if isLoading {
                    ProgressView()
                        .scaleEffect(2.5)
                }
                List(filteredCatBreeds) { breed in
                    ZStack(alignment: .leading) {
                        CatBreedRow(breed: breed)
                        NavigationLink(
                            destination: CatBreedDetailsView(
                                viewModel: CatBreedDetailsViewModel(
                                    api: viewModel.api,
                                    breed: breed)
                            )
                        ) {
                            EmptyView()
                        }
                        .opacity(0)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Cat Breeds")
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .onAppear {
            isLoading = true
            viewModel.refreshBreeds()
        }
        .onReceive(viewModel.$error) { error in
            if error == nil { return }
            isLoading = false
            didReceiveError = true
        }
        .onReceive(viewModel.$breeds) { _ in isLoading = false }
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
