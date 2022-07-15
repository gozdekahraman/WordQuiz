//
//  ScoreboardBuilder.swift
//  faceanswer
//
//  Created by gozde kahraman on 12.07.2022.
//

import Foundation
import UIKit

struct ScoreboardBuilder {
    static func build() -> UIViewController {
        let logger = FASingleton.instance.gameLogger
        let interactor = ScoreboardInteractor(logger: logger)
        let presenter = ScoreboardPresenter(interactor: interactor)
        let view = ScoreboardViewController(presenter: presenter)

        presenter.view = view
        interactor.output = presenter

        return view
    }
}
