//
//  HomePresenter.swift
//  faceanswer
//
//  Created by gozde kahraman on 9.07.2022.
//

import Foundation

protocol HomePresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapPlayButton()
    func didTapScoresButton()
}

final class HomePresenter: HomePresenterProtocol {

    weak var view: HomeViewProtocol?
    private let router: HomeRoutable

    init(router: HomeRoutable) {
        self.router = router
    }

    func viewDidLoad() {
        view?.configureLayout()
    }

    func didTapPlayButton() {
        router.navigateToRegistration()
    }

    func didTapScoresButton() {
        router.navigateToScoreboard()
    }
}
