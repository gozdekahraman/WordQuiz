//
//  ScoreboardPresenter.swift
//  faceanswer
//
//  Created by gozde kahraman on 12.07.2022.
//

import Foundation

struct ScoreboardViewModel {
    let logs: [GameLog]

    struct GameLog {
        let username: String?
        let score: String?
    }

    init(with logs: [FAGameLog]) {
        self.logs = logs.compactMap({GameLog.init(username: $0.username, score: $0.score)})
    }
}

protocol ScoreboardPresenterProtocol: AnyObject {
    func viewDidLoad()
}

final class ScoreboardPresenter: ScoreboardPresenterProtocol {
    weak var view: ScoreboardViewProtocol?
    private let interactor: ScoreboardInteractorProtocol
    private var viewModel: ScoreboardViewModel?

    init(interactor: ScoreboardInteractorProtocol) {
        self.interactor = interactor
    }

    func viewDidLoad() {
        view?.configureLayout()
        interactor.sessionDidBegin()
    }
}

// MARK: ScoreboardInteractorOutputable
extension ScoreboardPresenter: ScoreboardInteractorOutputable {
    func scoreboardInteractor(_ interactor: ScoreboardInteractorProtocol, didRetrieveLogs gameLogs: [FAGameLog]) {
        viewModel = ScoreboardViewModel(with: gameLogs)
        guard let viewModel = viewModel else { return }
        view?.configure(collectionViewWith: viewModel)
    }


}
