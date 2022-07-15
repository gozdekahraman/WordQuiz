//
//  HomeViewController.swift
//  faceanswer
//
//  Created by gozde kahraman on 8.07.2022.
//

import UIKit
import SnapKit

protocol HomeViewProtocol: AnyObject {
    func configureLayout()
}

class HomeViewController: UIViewController {
    // MARK: Subviews
    private lazy var gameTitle: UILabel = {
        let label = UILabel()
        label.text = "Face Answer"
        label.font = FAFont(fontName: .openSansBold, size: 32)
        label.textColor = FAColor(for: .darkAppColor)
        label.textAlignment = .center
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Try to find the most related word with group of keywords.\nAnswer questions by tilting your face vertically or horizontally."
        label.font = FAFont(fontName: .openSansRegular, size: 18)
        label.textColor = FAColor(for: .lightTextColor)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = FAFont(fontName: .openSansSemiBold, size: 14)
        button.layer.cornerRadius = 10
        button.setTitle("Play", for: .normal)
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
    private let presenter: HomePresenterProtocol

    init(presenter: HomePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        assertionFailure("HomeViewController failed to init. No file")
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

    @objc
    private func didTapPlayButton() {
        presenter.didTapPlayButton()
    }

    @objc
    private func didTapScoresButton() {
        presenter.didTapScoresButton()
    }
}

// MARK: HomeViewProtocol
extension HomeViewController: HomeViewProtocol {
    func configureLayout() {
        view.backgroundColor = .white
        view.addSubviews(gameTitle, descriptionLabel, playButton, scoreButton)
        configureConstrints()

        playButton.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        scoreButton.addTarget(self, action: #selector(didTapScoresButton), for: .touchUpInside)
    }
}

// MARK: Constraints
private extension HomeViewController {
    func configureConstrints() {
        gameTitle.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(gameTitle.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(32)
        }

        playButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(descriptionLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }

        scoreButton.snp.makeConstraints { make in
            make.top.equalTo(playButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            make.height.equalTo(50)
        }
    }
}
