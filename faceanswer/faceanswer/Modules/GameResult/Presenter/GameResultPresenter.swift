//
//  GameResultPresenter.swift
//  faceanswer
//
//  Created by gozde kahraman on 12.07.2022.
//

import Foundation

protocol GameResultPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapScoresButton()
    func didTapPayAgainButton()
}

final class GameResultPresenter: GameResultPresenterProtocol {
    weak var view: GameResultViewProtocol?
    private let router: GameResultRoutable
    private let interactor: GameResultInteractorProtocol

    init(interactor: GameResultInteractorProtocol, router: GameResultRoutable) {
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        view?.configureLayout()
        interactor.sessionDidBegin()
    }

    func didTapScoresButton() {
        router.navigateToScoreboard()
    }

    func didTapPayAgainButton() {
        router.navigateToHome()
    }
}

//MARK: GameResultInteractorOutputable
extension GameResultPresenter: GameResultInteractorOutputable {
    func gameResultInteractor(_ interactor: GameResultInteractorProtocol, didRetrieveScore score: Int) {
        view?.configure(with: score)
    }


}
