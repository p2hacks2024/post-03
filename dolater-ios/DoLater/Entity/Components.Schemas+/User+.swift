//
//  User+.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/10/24.
//

import FirebaseAuth

extension Components.Schemas.User {
    var profileURL: URL? {
        URL(string: "https://dolater.kantacky.com/users/\(id)")
    }
}

extension Components.Schemas.User {
    static let mock1 = Components.Schemas.User(
        id: UUID().uuidString,
        displayName: "Debug User1",
        photoURL: ""
    )

    static let mock2 = Components.Schemas.User(
        id: UUID().uuidString,
        displayName: "Debug User2",
        photoURL: ""
    )
}
