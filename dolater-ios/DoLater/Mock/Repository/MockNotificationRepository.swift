//
//  MockNotificationRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Foundation

final actor MockNotificationRepository: NotificationRepositoryProtocol {
    init() {}

    func getFCMToken() async throws -> String {
        ""
    }

    func postFCMToken(_ token: String) async throws {
    }

    func getNotifications() async throws -> [Components.Schemas.Notification] {
        [.mock1]
    }
}
