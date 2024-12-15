//
//  AuthRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/5/24.
//

import FirebaseAuth

protocol AuthRepositoryProtocol: Actor {
    func getCurrentUser() async throws -> User

    func update(displayName: String, for user: User) async throws

    func update(photoURL: URL, for user: User) async throws

    func update(email: String, for user: User) async throws

    func signOut() async throws
}

final actor AuthRepositoryImpl: AuthRepositoryProtocol {
    func getCurrentUser() async throws -> User {
        guard let user = Auth.auth().currentUser else {
            throw AuthRepositoryError.unauthenticated
        }
        return user
    }

    func update(displayName: String, for user: User) async throws {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        try await changeRequest.commitChanges()
    }

    func update(photoURL: URL, for user: User) async throws {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.photoURL = photoURL
        try await changeRequest.commitChanges()
    }

    func update(email: String, for user: User) async throws {
        // TODO: -
    }

    func signOut() async throws {
        try Auth.auth().signOut()
    }
}
