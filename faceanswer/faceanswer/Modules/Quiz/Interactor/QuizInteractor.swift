//
//  QuizInteractor.swift
//  faceanswer
//
//  Created by gozde kahraman on 11.07.2022.
//

import Foundation

struct GameResult {
    let correctAnswer: Int

    var point: Int {
        correctAnswer * 10
    }
}

struct QuizRawModel {
    let questions: [Question]

    struct Question {
        let keyWords: [String]
        let answers: [String]
        let correct: Int
    }

    init(with responseModel: QuizResponseModel) {
        questions = responseModel.quizlist.compactMap({
            Question.init(keyWords: $0.quiz,
                          answers: $0.option,
                          correct: $0.correct) })
    }
}


protocol QuizInteractorProtocol: AnyObject {
    func checkResult(question: QuestionViewModel)
    func retrieveQuiz()
    func retrieveQuestion()
}

protocol QuizInteractorOutputable: AnyObject {
    func quizInteractor(_ interactor: QuizInteractorProtocol, didRetrieveQuiz response: QuizResponseModel)
    func quizInteractor(_ interactor: QuizInteractorProtocol, didRetrieveQuestion question: QuizRawModel.Question)
    func quizInteractor(_ interactor: QuizInteractorProtocol, didGameOver result: GameResult)
    func quizInteractor(_ interactor: QuizInteractorProtocol, didAnswerQuestionCorrect question: QuestionViewModel)
    func quizInteractor(_ interactor: QuizInteractorProtocol, didAnswerQuestionWrong question: QuestionViewModel)
    func quizInteractor(_ interactor: QuizInteractorProtocol, didTimeOut question: QuestionViewModel)
}

final class QuizInteractor {
    weak var output: QuizInteractorOutputable?

    private var questionNumber = 0
    private var hasNextQuestion = true
    private var correctAnswers = 0

    private let repository: QuizRepositoryProtocol
    private var rawModel: QuizRawModel?
    private let category: String?

    init(repository: QuizRepositoryProtocol, category: String?) {
        self.repository = repository
        self.category = category
    }
}

// MARK: QuizInteractorProtocol
extension QuizInteractor: QuizInteractorProtocol {
    func retrieveQuiz() {
        repository.retrieveQuestions(with: category)
    }

    func checkResult(question: QuestionViewModel) {
        guard question.answer != .middle else {
            output?.quizInteractor(self, didTimeOut: question)
            return
        }
        if question.correctAnswer == question.answer {
            output?.quizInteractor(self, didAnswerQuestionCorrect: question)
            correctAnswers += 1
        } else {
            output?.quizInteractor(self, didAnswerQuestionWrong: question)
        }
    }

    func retrieveQuestion() {
        guard hasNextQuestion, let questions = rawModel?.questions else {
            output?.quizInteractor(self, didGameOver: GameResult(correctAnswer: correctAnswers))
            return
        }
        let question = questions[questionNumber]
        output?.quizInteractor(self, didRetrieveQuestion: question)
        questionNumber += 1
        hasNextQuestion = questions.count > questionNumber
    }
}

// MARK: CategorySelectionRepositoryOutputable
extension QuizInteractor: QuizRepositoryOutputable {
    func quizRepository(_ repository: QuizRepositoryProtocol, didRetrieveQuiz response: QuizResponseModel) {
        rawModel = QuizRawModel(with: response)
        output?.quizInteractor(self, didRetrieveQuiz: response)
    }

    func quizRepository(_ repository: QuizRepositoryProtocol, didRetrieveError error: Error) {
        // Handle error
    }


}
