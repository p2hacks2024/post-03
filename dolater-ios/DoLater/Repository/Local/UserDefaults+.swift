//
//  UserDefaults+.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Foundation

extension UserDefaults: @retroactive @unchecked Sendable {
    static let group = UserDefaults(suiteName: "group.com.kantacky.DoLater")
}
