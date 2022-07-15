//
//  CategoryCell.swift
//  faceanswer
//
//  Created by gozde kahraman on 10.07.2022.
//

import Foundation
import UIKit
import SnapKit

struct CategoryCellViewModel {
    let title: String
    let code: String
    let isSelected: Bool
}

final class CategoryCell: UICollectionViewCell {

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20
        view.layer.borderColor = FAColor(for: .lightAppColor).cgColor
        view.layer.borderWidth = 2
        return view
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = FAColor(for: .lightTextColor)
        label.font = FAFont(fontName: .openSansSemiBold, size: 14)
        return label
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
        containerView.addSubview(label)
        configureConstraints()
    }

    func configure(with viewModel: CategoryCellViewModel) {
        label.text = viewModel.title
        containerView.layer.borderColor = viewModel.isSelected ? FAColor(for: .darkAppColor).cgColor : FAColor(for: .lightAppColor).cgColor

    }
}

// MARK: Constraints
private extension CategoryCell {
    func configureConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }

        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview().inset(4)
        }
    }
}
