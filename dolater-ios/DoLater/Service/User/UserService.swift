//
//  UserService.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/14/24.
//

final actor UserService<Environment: EnvironmentProtocol> {
    init() {}

    func get(id: String) async throws -> Components.Schemas.User {
        try await Environment.shared.userRepository.getUser(id: id)
    }

    func follow(id: String) async throws -> Components.Schemas.FollowStatus {
        try await Environment.shared.userRepository.followUser(id: id)
    }

    func unfollow(id: String) async throws {
        try await Environment.shared.userRepository.unfollowUser(id: id)
    }
}
