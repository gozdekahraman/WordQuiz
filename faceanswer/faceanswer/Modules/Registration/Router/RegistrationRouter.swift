//
//  RegistrationRouter.swift
//  faceanswer
//
//  Created by gozde kahraman on 10.07.2022.
//

import Foundation
import UIKit

protocol RegistrationRoutable: AnyObject {
    func navigateToCategorySelection()
}

final class RegistrationRouter {
    weak var viewController: UIViewController?
}

extension RegistrationRouter: RegistrationRoutable {
    func navigateToCategorySelection() {
        guard let navigationController = viewController?.navigationController else { return }
        let categorySelectionVC = CategorySelectionBuilder.build()
        navigationController.pushViewController(categorySelectionVC, animated: true)
    }
}
