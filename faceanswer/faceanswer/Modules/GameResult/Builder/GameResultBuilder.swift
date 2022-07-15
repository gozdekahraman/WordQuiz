//
//  GameResultBuilder.swift
//  faceanswer
//
//  Created by gozde kahraman on 12.07.2022.
//

import Foundation
import UIKit

struct GameResultBuilder {
    static func build(with gameScore: Int) -> UIViewController {
        let router = GameResultRouter()
        let logger = FASingleton.instance.gameLogger
        let interactor = GameResultInteractor(gameScore: gameScore, logger: logger)
        let presenter = GameResultPresenter(interactor: interactor, router: router)
        let view = GameResultViewController(presenter: presenter)

        presenter.view = view
        interactor.output = presenter
        router.viewController = view

        return view
    }
}
