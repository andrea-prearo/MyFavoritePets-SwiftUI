//
//  PageControl.swift
//  MyFavoritePets-SwiftUI
//
//  Created by Andrea Prearo on 9/4/22.
//

import Foundation
import SwiftUI

// Code borrowed from: https://developer.apple.com/tutorials/swiftui/interfacing-with-uikit.
struct PageControl: UIViewRepresentable {
    var numberOfPages: Int
    @Binding var currentPage: Int
    var pageIndicatorTintColor: UIColor?
    var currentPageIndicatorTintColor: UIColor?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        control.pageIndicatorTintColor = pageIndicatorTintColor
        control.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        control.addTarget(
            context.coordinator,
            action: #selector(Coordinator.updateCurrentPage(sender:)),
            for: .valueChanged)
        control.addTarget(
            context.coordinator,
            action: #selector(Coordinator.updatePageIndicatorTintColor(_:)),
            for: .valueChanged)
        control.addTarget(
            context.coordinator,
            action: #selector(Coordinator.updateCurrentPageIndicatorTintColor(_:)),
            for: .valueChanged)
        return control
    }

    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
        uiView.pageIndicatorTintColor = pageIndicatorTintColor
        uiView.currentPageIndicatorTintColor = currentPageIndicatorTintColor
    }

    class Coordinator: NSObject {
        var control: PageControl

        init(_ control: PageControl) {
            self.control = control
        }

        @objc
        func updateCurrentPage(sender: UIPageControl) {
            control.currentPage = sender.currentPage
        }

        @objc
        func updatePageIndicatorTintColor(_ color: UIColor) {
            control.pageIndicatorTintColor = color
        }

        @objc
        func updateCurrentPageIndicatorTintColor(_ color: UIColor) {
            control.currentPageIndicatorTintColor = color
        }
    }
}
