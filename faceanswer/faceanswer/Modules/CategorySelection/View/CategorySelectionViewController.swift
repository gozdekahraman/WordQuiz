//
//  CategorySelectionViewController.swift
//  faceanswer
//
//  Created by gozde kahraman on 10.07.2022.
//

import Foundation
import UIKit
import SnapKit

protocol CategorySelectionViewProtocol: AnyObject {
    func configureLayout()
    func configure(collectionViewWith viewModel: QuizCategoriesViewModel) 
}

final class CategorySelectionViewController: UIViewController {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Select a category"
        label.font = FAFont(fontName: .openSansBold, size: 18)
        label.textColor = FAColor(for: .darkTextColor)
        label.textAlignment = .center
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: String(describing: CategoryCell.self))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = FAColor(for: .darkAppColor)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Start", for: .normal)
        button.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        return button
    }()

    // MARK: Properties
    private let presenter: CategorySelectionPresenterProtocol

    private var dataSource: CategoryCollectionViewDataSource?
    private var collectionViewDelegate = CategoryCollectionViewDelegate()

    init(presenter: CategorySelectionPresenterProtocol) {
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

    @objc
    private func didTapStartButton() {
        presenter.didTapStartButton()
    }

}

extension CategorySelectionViewController: CategorySelectionViewProtocol {
    func configureLayout() {
        view.backgroundColor = .white
        view.addSubviews(titleLabel, collectionView, startButton)
        configureConstraints()

        collectionView.delegate = collectionViewDelegate
        collectionViewDelegate.output = self
    }

    func configure(collectionViewWith viewModel: QuizCategoriesViewModel) {
        dataSource = CategoryCollectionViewDataSource(viewModel: viewModel)
        collectionView.dataSource = dataSource
        collectionViewDelegate.update(viewModel: viewModel)
        collectionView.reloadData()
    }
}

// MARK: Constraints
private extension CategorySelectionViewController {
    func configureConstraints() {
        configureTitleLabelConstraints()
        configureCollectionViewConstraints()
        configureSelectButtonConstraints()
    }

    func configureTitleLabelConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }

    func configureCollectionViewConstraints() {
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.centerY.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.height.equalTo(250)
        }
    }

    func configureSelectButtonConstraints() {
        startButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.greaterThanOrEqualTo(collectionView.snp.bottom).offset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            $0.height.equalTo(50)
        }
    }
}

// MARK: CategoryCollectionViewDelegateOutput
extension CategorySelectionViewController: CategoryCollectionViewDelegateOutput {
    func categoryCollectionView(_ delegate: CategoryCollectionViewDelegate, didSelectItemAt indexPath: IndexPath, with code: String) {
        presenter.didChangeCategorySelection(with: code)
    }
}
