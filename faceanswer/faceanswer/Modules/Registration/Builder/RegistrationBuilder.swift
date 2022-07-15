//
//  RegistrationBuilder.swift
//  faceanswer
//
//  Created by gozde kahraman on 10.07.2022.
//

import Foundation
import UIKit

struct RegistrationBuilder {
    static func build() -> UIViewController {
        let router = RegistrationRouter()
        let presenter = RegistrationPresenter(router: router)
        let view = RegistrationViewController(presenter: presenter)

        router.viewController = view
        presenter.view = view

        return view
    }
}
