//
//  CatBreedDetailsView.swift
//  MyFavoritePets
//
//  Created by Andrea Prearo on 9/2/22.
//

import Foundation
import SwiftUI

extension CatBreedImage: Identifiable {}

struct CatBreedDetailsView: View {
    private let viewModel: CatBreedDetailsViewModel
    private let breed: CatBreed

    private struct Constants {
        static let defaultInsets = EdgeInsets(top: 8, leading: 16, bottom: 8,trailing: 16)
        static let separatorSize: CGFloat = 2
        static let carouselItemHeight = UIScreen.main.bounds.height * 0.3 - Constants.defaultInsets.top - Constants.defaultInsets.bottom
    }

    init(viewModel: CatBreedDetailsViewModel) {
        self.viewModel = viewModel
        breed = viewModel.breed
    }

    var body: some View {
        VStack(spacing: 8) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(viewModel.breedImages) { image in
                        CatBreedCarouselImageView(breedImage: image,
                                        size: CGSize(width: Constants.carouselItemHeight,
                                                     height: Constants.carouselItemHeight))
                    }
                }
                .padding()
            }
            .frame(height: Constants.carouselItemHeight)
            Spacer()
            Text(breed.description)
                .multilineTextAlignment(.center)
                .padding(Constants.defaultInsets)
            LineDivider()
                .foregroundColor(Color.gray.opacity(0.5))
                .frame(height: Constants.separatorSize)
                .padding(Constants.defaultInsets)
            Text(breed.temperament)
                .multilineTextAlignment(.center)
                .padding(Constants.defaultInsets)
            Text("Origin: \(breed.origin)")
                .padding(Constants.defaultInsets)
            Text(viewModel.formattedWeight())
                .padding(Constants.defaultInsets)
        }
        .onAppear {
            viewModel.refreshBreedDetails()
        }
    }
}
