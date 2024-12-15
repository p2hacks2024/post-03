//
//  MockAuthRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import FirebaseAuth

final actor MockAuthRepository: AuthRepositoryProtocol {
    init() {}

    func getCurrentUser() async throws -> FirebaseAuth.User {
        .mock1
    }

    func update(displayName: String, for user: FirebaseAuth.User) async throws {
    }

    func update(photoURL: URL, for user: FirebaseAuth.User) async throws {
    }

    func update(email: String, for user: FirebaseAuth.User) async throws {
    }

    func signOut() async throws {
    }
}
