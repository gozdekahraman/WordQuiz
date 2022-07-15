//
//  QuizPresenter.swift
//  faceanswer
//
//  Created by gozde kahraman on 11.07.2022.
//

import Foundation
import AVFoundation

protocol QuizPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectFirstOption()
    func didSelectSecondOption()
    func didNotAnswer()
    func didTimeOut()
    func didTapNext()
    func evaluateCaptureOutput(in image: CVPixelBuffer)
}

final class QuizPresenter {

    weak var view: QuizViewProtocol?
    private let router: QuizRoutable
    private let interactor: QuizInteractorProtocol
    private var questionViewModel:  QuestionViewModel?
    private var gameState: GameState = .waitingForAnswer

    enum GameState {
        case waitingForAnswer
        case result
    }

    init(interactor: QuizInteractorProtocol, router: QuizRoutable) {
        self.interactor = interactor
        self.router = router
    }
}

extension QuizPresenter: QuizPresenterProtocol {
    func viewDidLoad() {
        view?.configureLayout()
        view?.showLoading()
        interactor.retrieveQuiz()
    }

    func evaluateCaptureOutput(in image: CVPixelBuffer) {
        guard gameState == .waitingForAnswer else { return }
        view?.detectFace(in: image)
    }

    func didSelectFirstOption() {
        guard gameState == .waitingForAnswer else { return }
        questionViewModel = questionViewModel?.updateAnswer(with: .left)
        view?.updateAnswerViews(with: questionViewModel?.answer)
    }

    func didSelectSecondOption() {
        guard gameState == .waitingForAnswer else { return }
        questionViewModel = questionViewModel?.updateAnswer(with: .right)
        view?.updateAnswerViews(with: questionViewModel?.answer)
    }

    func didNotAnswer() {
        guard gameState == .waitingForAnswer else { return }
        questionViewModel = questionViewModel?.updateAnswer(with: .middle)
        view?.updateAnswerViews(with: questionViewModel?.answer)
    }

    func didTimeOut() {
        guard let questionViewModel = questionViewModel else { return }
        interactor.checkResult(question: questionViewModel)
    }

    func didTapNext() {
        interactor.retrieveQuestion()
    }
}

// MARK: QuizInteractorOutputable
extension QuizPresenter: QuizInteractorOutputable {
    func quizInteractor(_ interactor: QuizInteractorProtocol, didRetrieveQuiz response: QuizResponseModel) {
        view?.dismissLoading()
        self.interactor.retrieveQuestion()
    }

    func quizInteractor(_ interactor: QuizInteractorProtocol, didRetrieveQuestion question: QuizRawModel.Question) {
        questionViewModel = QuestionViewModel(with: question)
        gameState = .waitingForAnswer
        view?.configure(questionViewWith: questionViewModel)
    }

    func quizInteractor(_ interactor: QuizInteractorProtocol, didGameOver result: GameResult) {
        router.navigateToGameResult(with: result)
    }

    func quizInteractor(_ interactor: QuizInteractorProtocol, didAnswerQuestionCorrect question: QuestionViewModel) {
        gameState = .result
        view?.playSound(for: .success)
        view?.configure(resultViewWith: question, status: .success)
    }

    func quizInteractor(_ interactor: QuizInteractorProtocol, didAnswerQuestionWrong question: QuestionViewModel) {
        gameState = .result
        view?.playSound(for: .fail)
        view?.configure(resultViewWith: question, status: .fail)
    }

    func quizInteractor(_ interactor: QuizInteractorProtocol, didTimeOut question: QuestionViewModel) {
        gameState = .result
        view?.playSound(for: .timeout)
        view?.configure(resultViewWith: question, status: .timeout)
    }


}
