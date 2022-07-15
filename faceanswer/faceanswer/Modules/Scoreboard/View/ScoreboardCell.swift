//
//  ScoreboardCell.swift
//  faceanswer
//
//  Created by gozde kahraman on 12.07.2022.
//

import Foundation
import UIKit
import SnapKit

final class ScoreboardCell: UICollectionViewCell {

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = FAColor(for: .lightAppColor).withAlphaComponent(0.5)
        return view
    }()

    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = FAColor(for: .darkTextColor)
        label.font = FAFont(fontName: .openSansRegular, size: 16)
        return label
    }()

    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = FAColor(for: .darkTextColor)
        label.font = FAFont(fontName: .openSansRegular, size: 16)
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()

    // - TAG: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
        stackView.addArrangedSubviews([usernameLabel, scoreLabel])
        configureConstraints()
    }

    func configure(with viewModel: ScoreboardViewModel.GameLog, isLast: Bool) {
        usernameLabel.text = viewModel.username
        scoreLabel.text = viewModel.score
        usernameLabel.font = isLast ? FAFont(fontName: .openSansBold, size: 14) : FAFont(fontName: .openSansRegular, size: 16)
        scoreLabel.font = isLast ? FAFont(fontName: .openSansBold, size: 14) : FAFont(fontName: .openSansRegular, size: 16)
    }
}

// MARK: Constraints
private extension ScoreboardCell {
    func configureConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }

        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(4)
        }
    }
}
