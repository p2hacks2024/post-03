//
//  User+.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import FirebaseAuth
import Foundation

extension FirebaseAuth.User: @retroactive @unchecked Sendable {
    static let mock1: FirebaseAuth.User = {
        let user = User(coder: .init())
        user?.uid = "0000000000000000000000000001"
        user?.displayName = "Debug User1"
        user?.photoURL = URL(string: "https://storage.googleapis.com/dolater-app.firebasestorage.app/profile_images/\(user?.uid ?? "")/\(UUID().uuidString).png")
        return user!
    }()

    static let mock2: FirebaseAuth.User = {
        let user = User(coder: .init())
        user?.uid = "0000000000000000000000000002"
        user?.displayName = "Debug User2"
        user?.photoURL = URL(string: "https://storage.googleapis.com/dolater-app.firebasestorage.app/profile_images/\(user?.uid ?? "")/\(UUID().uuidString).png")
        return user!
    }()
}
