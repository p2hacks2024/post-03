//
//  MockUserRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/10/24.
//

final actor MockUserRepository: UserRepositoryProtocol {
    init() {}

    func getUsers() async throws -> [Components.Schemas.User] {
        [.mock1]
    }

    func createUser() async throws -> Components.Schemas.User {
        .mock1
    }

    func getUser(id: Components.Parameters.id) async throws -> Components.Schemas.User {
        .mock1
    }

    func updateUser(_ user: Components.Schemas.UpdateUserInput, id: Components.Parameters.id)
        async throws -> Components.Schemas.User
    {
        var updatedUser = Components.Schemas.User.mock1
        if let displayName = user.displayName {
            updatedUser.displayName = displayName
        }
        if let photoURL = user.photoURL {
            updatedUser.photoURL = photoURL
        }
        return updatedUser
    }

    func deleteUser(id: Components.Parameters.id) async throws {
    }

    func getFollowings(id: Components.Parameters.uid) async throws -> [Components.Schemas.User] {
        [.mock1]
    }

    func getFollowers(id: Components.Parameters.uid) async throws -> [Components.Schemas.User] {
        [.mock2]
    }

    func getFriends(id: Components.Parameters.uid) async throws -> [Components.Schemas.User] {
        [.mock2]
    }

    func followUser(id: Components.Parameters.uid) async throws -> Components.Schemas.FollowStatus {
        .mock2
    }

    func unfollowUser(id: Components.Parameters.uid) async throws {
    }
}
