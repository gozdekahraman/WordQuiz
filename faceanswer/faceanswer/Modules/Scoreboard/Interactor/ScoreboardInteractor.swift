//
//  ScoreboardInteractor.swift
//  faceanswer
//
//  Created by gozde kahraman on 12.07.2022.
//

import Foundation
protocol ScoreboardInteractorProtocol: AnyObject {
    func sessionDidBegin()
}

protocol ScoreboardInteractorOutputable: AnyObject {
    func scoreboardInteractor(_ interactor: ScoreboardInteractorProtocol, didRetrieveLogs gameLogs: [FAGameLog])
}

final class ScoreboardInteractor {
    weak var output: ScoreboardInteractorOutputable?
    private let logger: GameLogger

    init(logger: GameLogger) {
        self.logger = logger
    }
}

extension ScoreboardInteractor: ScoreboardInteractorProtocol {
    func sessionDidBegin() {
        guard let gameLogs = logger.getAllLogs() else { return }
        output?.scoreboardInteractor(self, didRetrieveLogs: gameLogs)
    }
}
