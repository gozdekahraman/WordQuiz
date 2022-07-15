//
//  QuizRouter.swift
//  faceanswer
//
//  Created by gozde kahraman on 11.07.2022.
//

import Foundation
import UIKit

protocol QuizRoutable: AnyObject {
    func navigateToGameResult(with result: GameResult)
}

final class QuizRouter {
    weak var viewController: UIViewController?
}

extension QuizRouter: QuizRoutable {
    func navigateToGameResult(with result: GameResult) {
        guard let navigationController = viewController?.navigationController else { return }
        let gameResultVC = GameResultBuilder.build(with: result.point)
        navigationController.setViewControllers([gameResultVC], animated: true)
    }
}
