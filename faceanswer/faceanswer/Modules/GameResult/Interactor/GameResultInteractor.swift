//
//  GameResultInteractor.swift
//  faceanswer
//
//  Created by gozde kahraman on 12.07.2022.
//

import Foundation

protocol GameResultInteractorProtocol: AnyObject {
    func sessionDidBegin()
}

protocol GameResultInteractorOutputable: AnyObject {
    func gameResultInteractor(_ interactor: GameResultInteractorProtocol, didRetrieveScore score: Int)
}

final class GameResultInteractor {
    weak var output: GameResultInteractorOutputable?
    private let logger: GameLogger
    private let gameScore: Int

    init(gameScore: Int, logger: GameLogger) {
        self.gameScore = gameScore
        self.logger = logger
    }
}

extension GameResultInteractor: GameResultInteractorProtocol {
    func sessionDidBegin() {
        output?.gameResultInteractor(self, didRetrieveScore: gameScore)
        saveGameResult()
    }

    func saveGameResult() {
        guard let username = FASingleton.instance.username else { return }
        logger.addGameLog(log: FAGameLog(username: username, score: String(gameScore)))
    }
}
