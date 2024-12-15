//
//  Task+.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/10/24.
//

import Foundation
import SwiftUI

typealias DLTask = Components.Schemas.Task

extension Components.Schemas.Task: Identifiable, Transferable {
    var isPending: Bool {
        pool._type == .taskPoolTypePending
    }
    var isToDo: Bool {
        pool._type == .taskPoolTypeActive && completedAt == nil
    }
    var isCompleted: Bool {
        pool._type == .taskPoolTypeActive && completedAt != nil
    }
    var isRemoved: Bool {
        pool._type == .taskPoolTypeBin
    }
    var isArchived: Bool {
        pool._type == .taskPoolTypeArchived
    }

    var trashImage: Image {
        if isCompleted || isArchived {
            return .trashClosed
        }
        return .trashOpened
    }

    var passedDays: Int {
        let interval = Date().timeIntervalSince(createdAt)
        let passedDays = interval / TimeInterval(60 * 60 * 24)
        return Int(passedDays)
    }

    var radius: CGFloat {
        let maxInterval: TimeInterval = 60 * 60 * 24 * 7 * 4
        let interval = Date().timeIntervalSince(createdAt)
        let minRadius: CGFloat = 50
        let maxRadius: CGFloat = 100
        let width = maxRadius - minRadius
        let value = min(interval, maxInterval)
        let radius = minRadius + width * value / maxInterval
        return radius
    }

    var size: CGFloat {
        radius * 2
    }

    static let namePrefix: String = "task_"

    var displayName: String {
        "\(Self.namePrefix)\(id.lowercased())"
    }

    var isMyTask: Bool {
        owner.id == pool.owner?.id
    }

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: Self.self, contentType: .data)
    }
}

extension Components.Schemas.Task {
    static let mock1 = Components.Schemas.Task(
        id: UUID().uuidString,
        url: "https://developer.apple.com/design/human-interface-guidelines",
        createdAt: .now.addingTimeInterval(-TimeInterval.random(in: 0...60 * 60 * 24 * 7 * 4)),
        completedAt: .now,
        removedAt: .now,
        archivedAt: .now,
        owner: .mock1,
        pool: .mockArchived
    )
    static let mock2 = Components.Schemas.Task(
        id: UUID().uuidString,
        url: "https://developer.apple.com/documentation/swiftui",
        createdAt: .now.addingTimeInterval(-TimeInterval.random(in: 0...60 * 60 * 24 * 7 * 4)),
        completedAt: .now,
        owner: .mock1,
        pool: .mockActive
    )
    static let mock3 = Components.Schemas.Task(
        id: UUID().uuidString,
        url: "https://developer.apple.com/documentation/spritekit",
        createdAt: .now.addingTimeInterval(-TimeInterval.random(in: 0...60 * 60 * 24 * 7 * 4)),
        completedAt: .now,
        owner: .mock1,
        pool: .mockActive
    )
    static let mock4 = Components.Schemas.Task(
        id: UUID().uuidString,
        url: "https://developer.apple.com/documentation/scenekit",
        createdAt: .now.addingTimeInterval(-TimeInterval.random(in: 0...60 * 60 * 24 * 7 * 4)),
        owner: .mock1,
        pool: .mockActive
    )
    static let mock5 = Components.Schemas.Task(
        id: UUID().uuidString,
        url: "https://developer.apple.com/documentation/realitykit",
        createdAt: .now.addingTimeInterval(-TimeInterval.random(in: 0...60 * 60 * 24 * 7 * 4)),
        owner: .mock1,
        pool: .mockActive
    )
    static let mock6 = Components.Schemas.Task(
        id: UUID().uuidString,
        url: "https://developer.apple.com/documentation/ActivityKit",
        createdAt: .now.addingTimeInterval(-TimeInterval.random(in: 0...60 * 60 * 24 * 7 * 4)),
        completedAt: .now,
        owner: .mock1,
        pool: .mockActive
    )
    static let mock7 = Components.Schemas.Task(
        id: UUID().uuidString,
        url: "https://developer.apple.com/documentation/AppClip",
        createdAt: .now.addingTimeInterval(-TimeInterval.random(in: 0...60 * 60 * 24 * 7 * 4)),
        owner: .mock1,
        pool: .mockActive
    )
    static let mock8 = Components.Schemas.Task(
        id: UUID().uuidString,
        url: "https://developer.apple.com/documentation/AppIntents",
        createdAt: .now.addingTimeInterval(-TimeInterval.random(in: 0...60 * 60 * 24 * 7 * 4)),
        completedAt: .now,
        owner: .mock1,
        pool: .mockActive
    )
    static let mock9 = Components.Schemas.Task(
        id: UUID().uuidString,
        url: "https://note.com/solodoldrums/n/naaa56fe66cad?sub_rt=share_pb",
        createdAt: .now.addingTimeInterval(-TimeInterval.random(in: 0...60 * 60 * 24 * 7 * 4)),
        owner: .mock1,
        pool: .mockActive
    )

    static let mocks: [Components.Schemas.Task] = [
        .mock1,
        .mock2,
        .mock3,
        .mock4,
        .mock5,
        .mock6,
        .mock7,
        .mock8,
        .mock9,
    ]
}
