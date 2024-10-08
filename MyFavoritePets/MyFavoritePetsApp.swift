//
//  MyFavoritePetsApp.swift
//  MyFavoritePets
//
//  Created by Andrea Prearo on 8/29/22.
//

import SwiftUI

@main
struct MyFavoritePetsApp: App {
    @StateObject var viewModel = CatBreedsViewModel(api: CatApi())

    var body: some Scene {
        WindowGroup {
            CatBreedsView(viewModel:viewModel)
        }
    }
}
