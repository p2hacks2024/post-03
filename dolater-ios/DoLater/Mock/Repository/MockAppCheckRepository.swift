//
//  MockAppCheckRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import FirebaseAuth

final actor MockAppCheckRepository: AppCheckRepositoryProtocol {
    init() {}

    func getAppCheckToken() async throws -> String {
        ""
    }
}
