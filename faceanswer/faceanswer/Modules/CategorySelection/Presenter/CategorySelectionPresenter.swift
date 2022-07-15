//
//  CategorySelectionPresenter.swift
//  faceanswer
//
//  Created by gozde kahraman on 10.07.2022.
//

import Foundation

protocol CategorySelectionPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapStartButton()
    func didChangeCategorySelection(with code: String)
}

final class CategorySelectionPresenter {
    weak var view: CategorySelectionViewProtocol?

    private let router: CategorySelectionRoutable

    private var viewModel: QuizCategoriesViewModel

    init(router: CategorySelectionRoutable) {
        self.router = router
        self.viewModel = .init()
    }
}

// MARK: CategorySelectionPresenterProtocol
extension CategorySelectionPresenter: CategorySelectionPresenterProtocol {
    func viewDidLoad() {
        view?.configureLayout()
        view?.configure(collectionViewWith: viewModel)
    }

    func didTapStartButton() {
        router.navigateToQuiz(with: viewModel.selectedCategoryCode)
    }

    func didChangeCategorySelection(with code: String) {
        viewModel = viewModel.updateSelected(with: code)
        view?.configure(collectionViewWith: viewModel)
    }
}
