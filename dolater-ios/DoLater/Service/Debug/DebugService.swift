//
//  DebugService.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Foundation

final actor DebugService<Environment: EnvironmentProtocol> {
    func getServerEnvironment() async -> ServerEnvironment {
        let value = try? await Environment.shared.localRepository.getString(
            for: .serverEnvironment
        )
        return .init(rawValue: value ?? "") ?? .production
    }

    func setServerEnvironment(_ value: ServerEnvironment) async throws {
        try await Environment.shared.localRepository.setString(
            value.rawValue,
            for: .serverEnvironment
        )
    }

    func getSpriteKitDebugMode() async -> Bool {
        let value = try? await Environment.shared.localRepository.getBool(
            for: .isSpriteKitDebugModeEnabled
        )
        return value ?? false
    }

    func setSpriteKitDebugMode(_ value: Bool) async throws {
        try await Environment.shared.localRepository.setBool(
            value,
            for: .isSpriteKitDebugModeEnabled
        )
    }

    func getAppCheckToken() async throws -> String {
        try await Environment.shared.appCheckRepository.getAppCheckToken()
    }

    func getFCMToken() async throws -> String {
        try await Environment.shared.notificationRepository.getFCMToken()
    }

    func getUID() async throws -> String {
        let user = try await Environment.shared.authRepository.getCurrentUser()
        return user.uid
    }

    func getIdToken() async throws -> String {
        let user = try await Environment.shared.authRepository.getCurrentUser()
        return try await user.getIDToken(forcingRefresh: true)
    }
}
