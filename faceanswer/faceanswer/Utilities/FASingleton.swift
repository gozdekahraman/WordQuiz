//
//  FASingleton.swift
//  faceanswer
//
//  Created by gozde kahraman on 12.07.2022.
//

import Foundation

class FASingleton {
    static let instance: FASingleton = .init()
    let gameLogger: GameLogger = .init()
    var username: String?
    
    private init() {

    }
}
