//
//  FAColor.swift
//  faceanswer
//
//  Created by gozde kahraman on 9.07.2022.
//

import Foundation
import UIKit

typealias FAColor = UIColor

extension FAColor {
    enum FAColorResource {
        case lightTextColor
        case darkTextColor
        case darkAppColor
        case lightAppColor


        var value: String {
            return "\(self)"
        }
    }

    convenience init(for color: FAColorResource) {
        self.init(named: color.value)!
    }
}
