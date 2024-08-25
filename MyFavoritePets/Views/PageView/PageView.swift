//
//  PageView.swift
//  MyFavoritePets-SwiftUI
//
//  Created by Andrea Prearo on 9/4/22.
//

import Foundation
import SwiftUI

// Code borrowed from: https://developer.apple.com/tutorials/swiftui/interfacing-with-uikit.
struct PageView<Page: View>: View {
    var pages: [Page]
    var pageIndicatorTintColor: UIColor?
    var currentPageIndicatorTintColor: UIColor?
    @Binding var selectedPage: Int?
    @State private var currentPage = 0

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            PageViewController(pages: pages, currentPage: $currentPage)
            PageControl(numberOfPages: pages.count,
                        currentPage: $currentPage,
                        pageIndicatorTintColor: pageIndicatorTintColor,
                        currentPageIndicatorTintColor: currentPageIndicatorTintColor)
                .frame(width: CGFloat(pages.count * 18))
                .padding(.trailing)
        }.task {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                guard let page = selectedPage else { return }
                currentPage = page
            }
        }
    }
}
