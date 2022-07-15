//
//  RegistrationPresenter.swift
//  faceanswer
//
//  Created by gozde kahraman on 10.07.2022.
//

import Foundation

protocol RegistrationPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapContinueButton()
    func didChangeInput(with text: String)
}

final class RegistrationPresenter: RegistrationPresenterProtocol {

    weak var view: RegistrationViewProtocol?
    private let router: RegistrationRoutable

    init(router: RegistrationRoutable) {
        self.router = router
    }

    func viewDidLoad() {
        let inputViewModel = FAInputViewModel(text: "", placeholder: "username")
        view?.configureLayout()
        view?.configure(with: false)
        view?.configure(inputViewWith: inputViewModel)
    }

    func didTapContinueButton() {
        router.navigateToCategorySelection()
    }

    func didChangeInput(with text: String) {
        let isValid = text.count >= 2 && text.count <= 15 && !text.containsEmoji
        view?.configure(with: isValid)
        FASingleton.instance.username = isValid ? text : nil
    }
}
