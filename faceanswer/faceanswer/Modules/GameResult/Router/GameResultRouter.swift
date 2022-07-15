//
//  GameResultRouter.swift
//  faceanswer
//
//  Created by gozde kahraman on 12.07.2022.
//

import Foundation
import UIKit

protocol GameResultRoutable: AnyObject {
    func navigateToScoreboard()
    func navigateToHome()
}

final class GameResultRouter {
    weak var viewController: UIViewController?
}

extension GameResultRouter: GameResultRoutable {
    func navigateToScoreboard() {
        guard let navigationController = viewController?.navigationController else { return }
        let scoreboardVC = ScoreboardBuilder.build()
        navigationController.pushViewController(scoreboardVC, animated: true)
    }

    func navigateToHome() {
        guard let navigationController = viewController?.navigationController else { return }
        let homeVC = HomeBuilder.build()
        navigationController.setViewControllers([homeVC], animated: false)
    }
}
