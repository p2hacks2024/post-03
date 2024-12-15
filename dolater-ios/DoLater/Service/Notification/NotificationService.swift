//
//  NotificationService.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/15/24.
//

final actor NotificationService<Environment: EnvironmentProtocol> {
    init() {}

    func upsertFCMToken(_ token: String) async throws {
        try await Environment.shared.notificationRepository.postFCMToken(token)
    }

    func get() async throws -> [Components.Schemas.Notification] {
        try await Environment.shared.notificationRepository.getNotifications()
    }
}
