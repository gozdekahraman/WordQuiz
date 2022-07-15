//
//  RegistrationViewController.swift
//  faceanswer
//
//  Created by gozde kahraman on 9.07.2022.
//

import Foundation
import UIKit
import SnapKit

protocol RegistrationViewProtocol: AnyObject {
    func configureLayout()
    func configure(inputViewWith viewModel: FAInputViewModel)
    func configure(with isValid: Bool)
}

class RegistrationViewController: UIViewController {
    // MARK: Subviews
    private lazy var textField: FAInputView = {
        let textField = FAInputView()
        return textField
    }()

    private lazy var infoText: UILabel = {
        let label = UILabel()
        label.font = FAFont(fontName: .openSansRegular, size: 14)
        label.textColor = FAColor(for: .lightTextColor)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Username should have 2-15 characters and can not contain emoji!"
        return label
    }()

    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(FAColor(for: .lightTextColor), for: .disabled)
        button.layer.cornerRadius = 10
        button.setTitle("Next", for: .normal)
        button.backgroundColor = FAColor(for: .lightAppColor)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    // MARK: Properties
    private let presenter: RegistrationPresenterProtocol

    init(presenter: RegistrationPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        assertionFailure("RegistrationViewController failed to init. No file")
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

    @objc
    private func didTapContinueButton() {
        presenter.didTapContinueButton()
    }
}

// MARK: RegistrationViewProtocol
extension RegistrationViewController: RegistrationViewProtocol {
    func configureLayout() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        stackView.addArrangedSubviews([textField, infoText, continueButton])
        configureConstraints()

        continueButton.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        textField.delegate = self
        infoText.isHidden = true
    }

    func configure(with isValid: Bool) {
        continueButton.isEnabled = isValid
        continueButton.backgroundColor = isValid ? FAColor(for: .darkAppColor) : FAColor(for: .lightAppColor)
        infoText.isHidden = isValid
    }

    func configure(inputViewWith viewModel: FAInputViewModel) {
        textField.configure(with: viewModel)
    }
}

// MARK: Constraints
private extension RegistrationViewController {
    func configureConstraints() {
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }

        textField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }

        continueButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
}

// MARK: FAInputViewDelegate
extension RegistrationViewController: FAInputViewDelegate {
    func inputView(didEndTyping view: FAInputView, text: String) {
        presenter.didChangeInput(with: text)
    }
}
