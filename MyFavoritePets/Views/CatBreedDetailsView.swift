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
    @ObservedObject private var viewModel: CatBreedDetailsViewModel
    @State private var didReceiveError = false
    @State private var didSelectItem = false
    @State private var selectedItemIndex = -1
    private let breed: CatBreed

    private struct Constants {
        static let defaultInsets = EdgeInsets(top: 8, leading: 16, bottom: 8,trailing: 16)
        static let separatorSize: CGFloat = 2
        static let carouselImageSize = CGSize(width: 200, height: 200)
    }

    init(viewModel: CatBreedDetailsViewModel) {
        self.viewModel = viewModel
        breed = viewModel.breed
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
                                    size: Constants.carouselImageSize
                                )
                                .onTapGesture {
                                    selectedItemIndex = 0
                                    didSelectItem = true
                                }
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
                .padding(.bottom)
                Spacer()
            }
        }
        .padding(.bottom)
        .navigationBarTitle(breed.name)
        .onAppear {
            viewModel.refreshBreedDetails()
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
