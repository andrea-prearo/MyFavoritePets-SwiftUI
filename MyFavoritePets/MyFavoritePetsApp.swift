//
//  MyFavoritePetsApp.swift
//  MyFavoritePets
//
//  Created by Andrea Prearo on 8/29/22.
//

import SwiftUI

@main
struct MyFavoritePetsApp: App {
    @ObservedObject var viewModel = CatBreedsViewModel(api: CatApi.shared)

    var body: some Scene {
        WindowGroup {
            CatBreedsView(viewModel:viewModel)
        }
    }
}
