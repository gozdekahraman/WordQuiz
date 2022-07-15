//
//  HomeRouter.swift
//  faceanswer
//
//  Created by gozde kahraman on 9.07.2022.
//

import Foundation
import UIKit

protocol HomeRoutable: AnyObject {
    func navigateToRegistration()
    func navigateToScoreboard()
}

final class HomeRouter {
    weak var viewController: UIViewController?
}

extension HomeRouter: HomeRoutable {
    func navigateToRegistration() {
        guard let navigationController = viewController?.navigationController else { return }
        let registrationVC = RegistrationBuilder.build()
        navigationController.pushViewController(registrationVC, animated: true)
    }

    func navigateToScoreboard() {
        guard let navigationController = viewController?.navigationController else { return }
        let scoreboardVC = ScoreboardBuilder.build()
        navigationController.pushViewController(scoreboardVC, animated: true)
    }
}
