//
//  GameLogger.swift
//  faceanswer
//
//  Created by gozde kahraman on 12.07.2022.
//

import Foundation
import RealmSwift

final class FAGameLog: Object {
    @Persisted var username: String?
    @Persisted var score: String?

    convenience init(username: String, score: String) {
        self.init()
        self.username = username
        self.score = score
    }
}

final class GameLogger {
    private let localRealm: Realm?

    init() {
        do {
            let realm = try Realm()
            localRealm = realm
        } catch let error {
            localRealm = nil
            print(error.localizedDescription)
        }
    }

    func addGameLog(log: FAGameLog) {
        guard let localRealm = localRealm else { return }
        do {
            try localRealm.write {
                localRealm.add(log)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func getAllLogs() -> [FAGameLog]? {
        guard let localRealm = localRealm else { return nil }
        return localRealm.objects(FAGameLog.self).compactMap({ $0 })
    }
}
