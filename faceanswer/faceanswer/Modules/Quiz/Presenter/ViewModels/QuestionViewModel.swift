//
//  QuestionViewModel.swift
//  faceanswer
//
//  Created by gozde kahraman on 12.07.2022.
//

import Foundation

struct QuestionViewModel {
    let question: String
    let firstOption: String
    let secondOption: String
    let answer: ScreenSide
    let correctAnswer: ScreenSide

    enum ScreenSide {
        case left
        case middle
        case right
    }

    init(with rawModel: QuizRawModel.Question) {
        question = rawModel.keyWords.joined(separator: "\n")
        firstOption = rawModel.answers[0]
        secondOption = rawModel.answers[1]
        correctAnswer = rawModel.correct == 1 ? .left : .right
        answer = .middle
    }

    private init(question: String, firstOption: String, secondOption: String, answer: ScreenSide, correctAnswer: ScreenSide) {
        self.question = question
        self.firstOption = firstOption
        self.secondOption = secondOption
        self.answer = answer
        self.correctAnswer = correctAnswer
    }

    func updateAnswer(with selectedSide: ScreenSide) -> Self {
        Self(question: question, firstOption: firstOption, secondOption: secondOption, answer: selectedSide, correctAnswer: correctAnswer)
    }
}
