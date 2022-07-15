//
//  UIStackView+extension.swift
//  faceanswer
//
//  Created by gozde kahraman on 12.07.2022.
//

import Foundation
import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { view in
            addArrangedSubview(view)
        }
    }
}
