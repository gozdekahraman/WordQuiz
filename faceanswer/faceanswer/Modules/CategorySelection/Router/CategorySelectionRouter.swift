//
//  CategorySelectionRouter.swift
//  faceanswer
//
//  Created by gozde kahraman on 11.07.2022.
//

import Foundation
import UIKit

protocol CategorySelectionRoutable: AnyObject {
    func navigateToQuiz(with category: String?)
}

final class CategorySelectionRouter {
    weak var viewController: UIViewController?
}

extension CategorySelectionRouter: CategorySelectionRoutable {
    func navigateToQuiz(with category: String?) {
        guard let navigationController = viewController?.navigationController else { return }
        let quizVC = QuizBuilder.build(with: category)
        navigationController.pushViewController(quizVC, animated: true)
    }
}
