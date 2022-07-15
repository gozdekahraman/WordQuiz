//
//  ScoreboardViewController.swift
//  faceanswer
//
//  Created by gozde kahraman on 12.07.2022.
//

import Foundation
import UIKit
import SnapKit

protocol ScoreboardViewProtocol: AnyObject {
    func configureLayout()
    func configure(collectionViewWith viewModel: ScoreboardViewModel)
}

final class ScoreboardViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ScoreboardCell.self, forCellWithReuseIdentifier: String(describing: ScoreboardCell.self))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    // MARK: Properties
    private let presenter: ScoreboardPresenterProtocol

    private let collectionViewDelegate = ScoreboardCollectionViewDelegate()
    private var dataSource: ScoreboardCollectionViewDataSource?

    init(presenter: ScoreboardPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("CategorySelectionViewController failed to init. No file")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension ScoreboardViewController: ScoreboardViewProtocol {
    func configureLayout() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(32)
        }
        collectionView.delegate = collectionViewDelegate
    }

    func configure(collectionViewWith viewModel: ScoreboardViewModel) {
        dataSource = ScoreboardCollectionViewDataSource(viewModel: viewModel)
        collectionView.dataSource = dataSource
        collectionView.reloadData()
    }
}
