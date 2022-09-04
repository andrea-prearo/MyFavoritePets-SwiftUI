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
