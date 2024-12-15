//
//  Notification+.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/15/24.
//

import Foundation

extension Components.Schemas.Notification: Identifiable {
    static let mock1 = Components.Schemas.Notification(
        id: UUID().uuidString,
        title: "あなたのあとまわしリンクが溢れました",
        createdAt: .now
    )
}
