//
//  CatBreedRow.swift
//  MyFavoritePets
//
//  Created by Andrea Prearo on 9/2/22.
//

import Foundation
import Kingfisher
import SwiftUI

struct CatBreedRow: View {
    private let breed: CatBreed
    private let processor: ImageProcessor

    private struct Constants {
        static let thumbnailSize: CGFloat = 32
        static let thumbnailRadius: CGFloat = thumbnailSize * 0.5
        static let insets = UIEdgeInsets(top: 8, left: 16, bottom: -8, right: -16)
    }

    init(breed: CatBreed) {
        self.breed = breed
        processor = DownsamplingImageProcessor(size: CGSize(width: Constants.thumbnailSize,
                                                            height: Constants.thumbnailSize))
            |> RoundCornerImageProcessor(cornerRadius: Constants.thumbnailRadius)
    }

    var body: some View {
        HStack {
            KFImage(URL(string: breed.imageURL() ?? ""))
                .placeholder { Image("CatBreedPlaceholder") }
                .setProcessor(processor)
                .fade(duration: 1)
                .cacheOriginalImage()
                .frame(width: Constants.thumbnailSize, height: Constants.thumbnailSize)
            Text(breed.name)
        }
    }
}
