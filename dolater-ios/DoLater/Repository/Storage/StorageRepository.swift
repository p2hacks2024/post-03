//
//  StorageRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import FirebaseStorage
import Foundation

protocol StorageRepositoryProtocol: Actor {
    func upload(_ data: Data, to path: String) async throws -> StorageMetadata
}

final actor StorageRepositoryImpl: StorageRepositoryProtocol {
    private let storage: Storage = .storage()

    init() {}

    func upload(_ data: Data, to path: String) async throws -> StorageMetadata {
        let storageRef = storage.reference()
        let fileRef = storageRef.child(path)
        return try await fileRef.putDataAsync(data)
    }
}
