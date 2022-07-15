//
//  CategorySelectionBuilder.swift
//  faceanswer
//
//  Created by gozde kahraman on 11.07.2022.
//

import Foundation
import UIKit

struct CategorySelectionBuilder {
    static func build() -> UIViewController {
        let router = CategorySelectionRouter()
        let presenter = CategorySelectionPresenter(router: router)
        let view = CategorySelectionViewController(presenter: presenter)

        presenter.view = view
        router.viewController = view

        return view
    }
}
