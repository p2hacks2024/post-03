//
//  TaskPool+.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/10/24.
//

import Foundation

extension Components.Schemas.TaskPool {
    static let mockActive = Components.Schemas.TaskPool(
        id: UUID().uuidString,
        _type: .taskPoolTypeActive
    )

    static let mockArchived = Components.Schemas.TaskPool(
        id: UUID().uuidString,
        _type: .taskPoolTypeArchived
    )

    static let mockBin = Components.Schemas.TaskPool(
        id: UUID().uuidString,
        _type: .taskPoolTypeBin
    )

    static let mockPending = Components.Schemas.TaskPool(
        id: UUID().uuidString,
        _type: .taskPoolTypePending
    )

    static let mocks: [Components.Schemas.TaskPool] = [
        .mockActive,
        .mockArchived,
        .mockBin,
        .mockPending,
    ]
}
