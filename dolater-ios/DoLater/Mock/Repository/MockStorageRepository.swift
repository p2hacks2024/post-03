//
//  MockStorageRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import FirebaseStorage
import Foundation

final actor MockStorageRepository: StorageRepositoryProtocol {
    init() {}

    func upload(_ data: Data, to path: String) async throws -> FirebaseStorage.StorageMetadata {
        .init(dictionary: [:])
    }
}
