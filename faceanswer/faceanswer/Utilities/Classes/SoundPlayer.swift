//
//  SoundPlayer.swift
//  faceanswer
//
//  Created by gozde kahraman on 12.07.2022.
//

import Foundation
import AVFoundation

final class SoundPlayer {
    static private let successSoundID: SystemSoundID = 1111
    static private let failSoundID: SystemSoundID = 1006
    static private let timeOutSoundID: SystemSoundID = 1003

    static func playSuccessSound() {
        AudioServicesPlaySystemSound(successSoundID)
    }

    static func playFailSound() {
        AudioServicesPlaySystemSound(failSoundID)
    }

    static func playTimeOutSound() {
        AudioServicesPlaySystemSound(timeOutSoundID)
    }
}
