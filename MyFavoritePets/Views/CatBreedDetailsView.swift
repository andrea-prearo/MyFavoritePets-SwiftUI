//
//  CatBreedDetailsView.swift
//  MyFavoritePets
//
//  Created by Andrea Prearo on 9/2/22.
//

import Foundation
import SwiftUI

struct CatBreedDetailsView: View {
    private let viewModel: CatBreedDetailsViewModel
    private let breed: CatBreed
    private let carouselItemHeight: CGFloat
    private let defaultInsets = EdgeInsets(top: 8, leading: 16, bottom: 8,trailing: 16)

    private struct Constants {
        static let separatorSize: CGFloat = 2
    }

    init(viewModel: CatBreedDetailsViewModel) {
        self.viewModel = viewModel
        breed = viewModel.breed

        carouselItemHeight = UIScreen.main.bounds.height * 0.3 - defaultInsets.top - defaultInsets.bottom
    }

    var body: some View {
        VStack(spacing: 8) {
            ScrollView(.horizontal) {
//                HStack(spacing: 8) {
//                    ForEach(viewModel.breedImages) { image in
//
//                    }
//                }
            }
            .frame(height: carouselItemHeight)
            Text(breed.description)
                .multilineTextAlignment(.center)
                .padding(defaultInsets)
            LineDivider()
                .foregroundColor(Color.gray.opacity(0.5))
                .frame(height: Constants.separatorSize)
                .padding(defaultInsets)
            Text(breed.temperament)
                .multilineTextAlignment(.center)
                .padding(defaultInsets)
            Text("Origin: \(breed.origin)")
                .padding(defaultInsets)
            Text(viewModel.formattedWeight())
                .padding(defaultInsets)
        }
        .onAppear {
            viewModel.refreshBreedDetails()
        }
    }
}
