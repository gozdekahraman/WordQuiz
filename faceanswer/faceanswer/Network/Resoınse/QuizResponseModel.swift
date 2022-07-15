//
//  QuizResponseModel.swift
//  faceanswer
//
//  Created by gozde kahraman on 12.07.2022.
//

import Foundation

struct QuizResponseModel: Decodable {
    let area: String
    let level: Int
    let quizlist: [Quiz]

    struct Quiz: Decodable {
        let correct: Int
        let option: [String]
        let quiz: [String]
    }
}
