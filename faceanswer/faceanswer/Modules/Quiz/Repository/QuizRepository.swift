//
//  QuizRepository.swift
//  faceanswer
//
//  Created by gozde kahraman on 11.07.2022.
//

import Foundation

protocol QuizRepositoryProtocol: AnyObject {
    func retrieveQuestions(with category: String?)
}

protocol QuizRepositoryOutputable: AnyObject {
    func quizRepository(_ repository: QuizRepositoryProtocol, didRetrieveQuiz response: QuizResponseModel)
    func quizRepository(_ repository: QuizRepositoryProtocol, didRetrieveError error: Error)
}

final class QuizRepository {
    private let quizAPI: QuizAPI

    weak var output: QuizRepositoryOutputable?

    init(quizAPI: QuizAPI) {
        self.quizAPI = quizAPI
    }
}

// MARK: QuizRepositoryProtocol
extension QuizRepository: QuizRepositoryProtocol {
    func retrieveQuestions(with category: String?) {
        let request = QuizRequestModel(area: category)

        quizAPI.fetchQuiz(with: request) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                self.output?.quizRepository(self, didRetrieveQuiz: response.response)
            case .failure(let error):
                self.output?.quizRepository(self, didRetrieveError: error)
            }
        }
    }
}
