//
//  GameResultViewController.swift
//  faceanswer
//
//  Created by gozde kahraman on 12.07.2022.
//

import Foundation
import UIKit
import SnapKit

protocol GameResultViewProtocol: AnyObject {
    func configureLayout()
    func configure(with score: Int)
}

class GameResultViewController: UIViewController {
    // MARK: Subviews
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Game Over"
        label.font = FAFont(fontName: .openSansBold, size: 32)
        label.textColor = FAColor(for: .darkAppColor)
        label.textAlignment = .center
        return label
    }()

    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.font = FAFont(fontName: .openSansRegular, size: 36)
        label.textColor = FAColor(for: .lightTextColor)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var playAgainButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = FAFont(fontName: .openSansSemiBold, size: 14)
        button.layer.cornerRadius = 10
        button.setTitle("Play Again", for: .normal)
        button.backgroundColor = FAColor(for: .darkAppColor)
        return button
    }()

    private lazy var scoreButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = FAFont(fontName: .openSansSemiBold, size: 14)
        button.layer.cornerRadius = 10
        button.setTitle("Scoreboard", for: .normal)
        button.backgroundColor = FAColor(for: .darkTextColor)
        return button
    }()

    // MARK: Properties
    private let presenter: GameResultPresenterProtocol

    init(presenter: GameResultPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        assertionFailure("GameResultViewController failed to init. No file")
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

    @objc
    private func didTapScoresButton() {
        presenter.didTapScoresButton()
    }

    @objc
    private func didTapPayAgainButton() {
        presenter.didTapPayAgainButton()
    }
}

// MARK: GameResultViewProtocol
extension GameResultViewController: GameResultViewProtocol {
    func configureLayout() {
        view.backgroundColor = .white
        view.addSubviews(titleLabel, scoreLabel, playAgainButton, scoreButton)
        configureConstrints()
        scoreButton.addTarget(self, action: #selector(didTapScoresButton), for: .touchUpInside)
        playAgainButton.addTarget(self, action: #selector(didTapPayAgainButton), for: .touchUpInside)
    }

    func configure(with score: Int) {
        scoreLabel.text = "Score\n\(String(score))"
    }
}

// MARK: Constraints
private extension GameResultViewController {
    func configureConstrints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
        }

        scoreLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualTo(titleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(32)
        }

        playAgainButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(scoreLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }

        scoreButton.snp.makeConstraints { make in
            make.top.equalTo(playAgainButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            make.height.equalTo(50)
        }
    }
}
