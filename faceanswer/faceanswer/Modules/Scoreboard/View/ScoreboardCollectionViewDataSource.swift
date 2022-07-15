//
//  ScoreboardCollectionViewDataSource.swift
//  faceanswer
//
//  Created by gozde kahraman on 12.07.2022.
//

import Foundation
import UIKit

final class ScoreboardCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    // MARK: Properties
    private let viewModel: ScoreboardViewModel

    init(viewModel: ScoreboardViewModel) {
        self.viewModel = viewModel
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.logs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ScoreboardCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ScoreboardCell.self), for: indexPath) as? ScoreboardCell else {
            fatalError("Scoreboard cell could not be dequeued.")
        }
        let isLastLog = indexPath.row == viewModel.logs.count - 1
        cell.configure(with: viewModel.logs[indexPath.row], isLast: isLastLog)
        return cell
    }
}
