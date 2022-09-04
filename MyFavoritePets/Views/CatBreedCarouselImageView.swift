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
    private let processor: ImageProcessor?
    private let size: CGSize

    private struct Constants {
        static let imageRadius: CGFloat = 20
    }

    init(breedImage: CatBreedImage, size: CGSize, justFit: Bool) {
        self.breedImage = breedImage
        self.size = size
        if justFit == false {
            processor = CroppingImageProcessor(size: CGSize(width: size.width, height: size.height),
                                               anchor: CGPoint(x: 0.5, y: 0.5))
            |> RoundCornerImageProcessor(cornerRadius: Constants.imageRadius)
        } else {
            processor = nil
        }
    }

    var body: some View {
        if let processor = processor {
            KFImage(URL(string: breedImage.url))
                .placeholder { Image("CatBreedPlaceholder") }
                .setProcessor(processor)
                .fade(duration: 1)
                .cacheOriginalImage()
        } else {
            KFImage(URL(string: breedImage.url))
                .placeholder { Image("CatBreedPlaceholder") }
                .fade(duration: 1)
                .cacheOriginalImage()
                .resizable()
                .scaledToFit()
        }
    }
}
