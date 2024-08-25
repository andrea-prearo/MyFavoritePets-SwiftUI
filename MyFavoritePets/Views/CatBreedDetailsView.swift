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
    @StateObject var viewModel: CatBreedDetailsViewModel
    @State var breed: CatBreed
    @State private var didReceiveError = false
    @State private var didSelectItem = false
    @State private var selectedItemIndex: Int?

    private struct Constants {
        static let defaultInsets = EdgeInsets(top: 8, leading: 16, bottom: 8,trailing: 16)
        static let separatorSize: CGFloat = 2
        static let carouselImageSize = CGSize(width: 200, height: 200)
        static let viewWidth = Int(UIScreen.main.bounds.width)
        static let viewHeight = Int(UIScreen.main.bounds.height - 80)
    }

    var body: some View {
        ScrollView {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.breedImages) { image in
                            ZStack {
                                CatBreedCarouselImageView(
                                    breedImage: image,
                                    size: Constants.carouselImageSize,
                                    justFit: false
                                )
                                .onTapGesture {
                                    selectedItemIndex = viewModel.breedImages.firstIndex(where: { img in
                                        img == image
                                    })
                                    didSelectItem = true
                                }
                                NavigationLink(isActive: $didSelectItem) {
                                    PageView(pages: viewModel.breedImages.map { image in
                                        CatBreedCarouselImageView(breedImage: image,
                                                                  size: CGSize(width: Constants.viewWidth,
                                                                               height: Constants.viewHeight),
                                                                  justFit: true)
                                        },
                                        pageIndicatorTintColor: .gray,
                                        currentPageIndicatorTintColor: .black,
                                        selectedPage: $selectedItemIndex
                                    )
                                    .navigationBarTitle(breed.name)
                                } label: {
                                    Text("Hidden link to carousel view")
                                }
                                .hidden()
                            }
                        }
                    }
                    .frame(height: Constants.carouselImageSize.height)
                    .padding(Constants.defaultInsets)
                }
                .fixedSize(horizontal: false, vertical: true)
                VStack {
                    Spacer()
                    Text(breed.description)
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(Constants.defaultInsets)
                    LineDivider()
                        .foregroundColor(Color.gray.opacity(0.5))
                        .frame(height: Constants.separatorSize)
                        .padding(Constants.defaultInsets)
                    Text(breed.temperament)
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(Constants.defaultInsets)
                    Text("Origin: \(breed.origin)")
                        .padding(Constants.defaultInsets)
                    Text(viewModel.formattedWeight())
                        .padding(Constants.defaultInsets)
                    Spacer()
                }
                .scaledToFit()
                Spacer()
            }
        }
        .navigationBarTitle(breed.name)
        .task {
            viewModel.refreshBreedDetails()
        }
        .onReceive(viewModel.$error) { error in
            if error == nil { return }
            didReceiveError = true
        }
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
