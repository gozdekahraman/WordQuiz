//
//  FAFont.swift
//  faceanswer
//
//  Created by gozde kahraman on 9.07.2022.
//

import Foundation
import UIKit

public typealias FAFont = UIFont

// MARK: Fonts
extension FAFont {
    enum FontName: String, CaseIterable {
        case openSansLight = "OpenSans-Light"
        case openSansRegular = "OpenSans-Regular"
        case openSansSemiBold = "OpenSans-SemiBold"
        case openSansBold = "OpenSans-Bold"
    }

    convenience init(fontName: FontName, size: CGFloat) {
        self.init(name: fontName.rawValue, size: size)!
    }
}
