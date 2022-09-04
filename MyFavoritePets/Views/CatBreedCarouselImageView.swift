//
//  CatCarouselView.swift
//  MyFavoritePets
//
//  Created by Andrea Prearo on 9/2/22.
//

import Foundation
import Kingfisher
import SwiftUI

struct CatBreedCarouselImageView: View {
    private let breedImage: CatBreedImage
    private let processor: ImageProcessor
    private let size: CGSize

    private struct Constants {
        static let imageRadius: CGFloat = 20
    }

    init(breedImage: CatBreedImage, size: CGSize) {
        self.breedImage = breedImage
        self.size = size
        processor = CroppingImageProcessor(size: CGSize(width: size.width, height: size.height),
                                           anchor: CGPoint(x: 0.5, y: 0.5))
        |> RoundCornerImageProcessor(cornerRadius: Constants.imageRadius)
    }

    var body: some View {
        KFImage(URL(string: breedImage.url))
            .placeholder { Image("CatBreedPlaceholder") }
            .setProcessor(processor)
            .fade(duration: 1)
            .cacheOriginalImage()
    }
}
