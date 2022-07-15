//
//  FAInputView.swift
//  faceanswer
//
//  Created by gozde kahraman on 9.07.2022.
//

import Foundation
import UIKit
import SnapKit

struct FAInputViewModel {
    let text: String
    let placeholder: String
}

protocol FAInputViewDelegate: AnyObject {
    func inputView(didEndTyping view: FAInputView, text: String)
}

final class FAInputView: UIView {
    // MARK: - Subviews
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.clearButtonMode = .whileEditing
        textField.textColor = FAColor(for: .darkTextColor)
        textField.font = FAFont(fontName: .openSansSemiBold, size: 14)
        return textField
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderColor = FAColor(for: .lightAppColor).cgColor
        view.layer.borderWidth = 1
        return view
    }()

    // MARK: - Properties
    private let placeholderAttributes: [NSAttributedString.Key : Any] = [
        .foregroundColor : FAColor(for: .lightTextColor),
        .font : FAFont(fontName: .openSansSemiBold, size: 14)
    ]

    weak var delegate: FAInputViewDelegate?

    /// - TAG: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        addSubview(containerView)
        containerView.addSubview(textField)
        configureConstraints()
        textField.addTarget(self, action: #selector(textFieldDidEndTyping), for: .editingChanged)
    }

    func configure(with viewModel: FAInputViewModel) {
        textField.attributedPlaceholder = NSAttributedString(string: viewModel.placeholder, attributes: placeholderAttributes)
        textField.text = viewModel.text
    }

    @objc
    private func textFieldDidEndTyping() {
        delegate?.inputView(didEndTyping: self, text: textField.text ?? "")
    }
}

// MARK: Constraints
private extension FAInputView {
    func configureConstraints() {
        configureContainerViewConstraints()
        configureStackViewConstraints()
    }

    func configureContainerViewConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configureStackViewConstraints() {
        textField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
