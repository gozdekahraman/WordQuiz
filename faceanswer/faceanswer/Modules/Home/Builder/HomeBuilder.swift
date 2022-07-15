//
//  HomeBuilder.swift
//  faceanswer
//
//  Created by gozde kahraman on 9.07.2022.
//

import Foundation
import UIKit

struct HomeBuilder {
    static func build() -> UIViewController {
        let router = HomeRouter()
        let presenter = HomePresenter(router: router)
        let view = HomeViewController(presenter: presenter)

        router.viewController = view
        presenter.view = view

        return view
    }
}
