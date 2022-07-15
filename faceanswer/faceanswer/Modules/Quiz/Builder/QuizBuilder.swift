//
//  QuizBuilder.swift
//  faceanswer
//
//  Created by gozde kahraman on 11.07.2022.
//

import Foundation
import UIKit

struct QuizBuilder {
    static func build(with category: String?) -> UIViewController {
        let router = QuizRouter()
        let quizAPI = QuizAPI()
        let repository = QuizRepository(quizAPI: quizAPI)
        let interactor = QuizInteractor(repository: repository, category: category)
        let presenter = QuizPresenter(interactor: interactor, router: router)
        let view = QuizViewController(presenter: presenter)

        presenter.view = view
        interactor.output = presenter
        repository.output = interactor
        router.viewController = view

        return view
    }
}
