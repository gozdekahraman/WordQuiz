//
//  CategoryCollectionViewDelegate.swift
//  faceanswer
//
//  Created by gozde kahraman on 10.07.2022.
//

import Foundation
import UIKit

protocol CategoryCollectionViewDelegateOutput: AnyObject {
    func categoryCollectionView(_ delegate: CategoryCollectionViewDelegate, didSelectItemAt indexPath: IndexPath, with code: String)
}

final class CategoryCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    private enum Constants {
        static let cellHeight: CGFloat = 50
    }

    private(set) var viewModel: QuizCategoriesViewModel?

    weak var output: CategoryCollectionViewDelegateOutput?

    func update(viewModel: QuizCategoriesViewModel) {
        self.viewModel = viewModel
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel?.categories[indexPath.row] else { return }
        output?.categoryCollectionView(self, didSelectItemAt: indexPath, with: viewModel.code)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CategoryCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: Constants.cellHeight)
    }
}
