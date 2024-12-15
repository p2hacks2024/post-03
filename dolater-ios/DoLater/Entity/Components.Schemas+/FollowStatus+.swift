//
//  FollowStatus+.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/13/24.
//

extension Components.Schemas.FollowStatus {
    static let mock1 = Components.Schemas.FollowStatus(
        from: .mock1,
        to: .mock2,
        timestamp: .now.addingTimeInterval(-60 * 60 * 24 * 3)
    )

    static let mock2 = Components.Schemas.FollowStatus(
        from: .mock2,
        to: .mock1,
        timestamp: .now.addingTimeInterval(-60 * 60 * 24 * 3)
    )
}
