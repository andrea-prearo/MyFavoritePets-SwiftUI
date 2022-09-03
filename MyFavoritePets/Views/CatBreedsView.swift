//
//  CatBreedsView.swift
//  MyFavoritePets
//
//  Created by Andrea Prearo on 8/29/22.
//

import SwiftUI

extension CatBreed: Identifiable {}

struct CatBreedsView: View {
    @ObservedObject var viewModel: CatBreedsViewModel

    var body: some View {
        NavigationView {
            List(viewModel.breeds) { breed in
              NavigationLink(
                destination: CatBreedDetailsView(breed: breed)) {
                    CatBreedRow(breed: breed)
              }
            }.navigationTitle("Cat Breeds")
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
