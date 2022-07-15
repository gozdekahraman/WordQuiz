//
//  TimerView.swift
//  faceanswer
//
//  Created by gozde kahraman on 11.07.2022.
//

import Foundation
import UIKit
import SnapKit

protocol TimerViewDelegate: AnyObject {
    func timerView(didTimeOut view: TimerView)
}

final class TimerView: UIView {
    // MARK: - Subviews
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = FAFont(fontName: .openSansBold, size: 26)
        label.text = time.description
        return label
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = FAColor(for: .darkTextColor)
        return view
    }()

    weak var delegate: TimerViewDelegate?
    private var time = 10

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
        containerView.addSubview(label)
        configureConstraints()
    }

    func reStartTimer() {
        time = 10
        label.text = time.description
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.time > 0 {
                self.time -= 1
                self.label.text = self.time.description
            } else {
                self.label.text = "Time is up!"
                self.delegate?.timerView(didTimeOut: self)
                timer.invalidate()
            }
        }
    }
}

// MARK: Constraints
private extension TimerView {
    func configureConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(24)
        }
    }
}
