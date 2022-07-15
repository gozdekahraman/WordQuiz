//
//  CategoryCollectionViewDataSource.swift
//  faceanswer
//
//  Created by gozde kahraman on 10.07.2022.
//

import Foundation
import UIKit

struct QuizCategoriesViewModel {
    let categories: [CategoryCellViewModel]

    var selectedCategoryCode: String? {
        categories.first(where: { $0.isSelected })?.code
    }

    enum QuizCategories: String, CaseIterable {
        case sat
        case ielts
        case toefl
        case gre
        case overall
    }

    init() {
        categories = QuizCategories.allCases.map { CategoryCellViewModel.init(title: $0 == .overall ? $0.rawValue.capitalized : $0.rawValue.uppercased(), code: $0.rawValue, isSelected: false)}
    }

    init(categories: [CategoryCellViewModel]) {
        self.categories = categories
    }

    func updateSelected(with code: String) -> Self {
        Self(categories: categories.compactMap({ CategoryCellViewModel.init(title: $0.title, code: $0.code, isSelected: $0.code == code) }))
    }
}

final class CategoryCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    // MARK: Properties
    private let viewModel: QuizCategoriesViewModel

    init(viewModel: QuizCategoriesViewModel) {
        self.viewModel = viewModel
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: CategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoryCell.self), for: indexPath) as? CategoryCell else {
            fatalError("Category cell could not be dequeued.")
        }
        cell.configure(with: viewModel.categories[indexPath.row])
        return cell
    }
}
