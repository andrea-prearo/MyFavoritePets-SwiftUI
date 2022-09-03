//
//  CatBreedRow.swift
//  MyFavoritePets
//
//  Created by Andrea Prearo on 9/2/22.
//

import Foundation
import SwiftUI

struct CatBreedRow: View {
    let breed: CatBreed

    var body: some View {
        Text(breed.name)
    }
}
