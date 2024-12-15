//
//  MockRemoteConfigRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Foundation

final actor MockRemoteConfigRepository: RemoteConfigRepositoryProtocol {
    init() {}

    func fetchBool(for key: RemoteConfigKey) async throws -> Bool {
        false
    }

    func fetchData(for key: RemoteConfigKey) async throws -> Data {
        .init()
    }

    func fetchDouble(for key: RemoteConfigKey) async throws -> Double {
        0
    }

    func fetchInt(for key: RemoteConfigKey) async throws -> Int {
        0
    }

    func fetchString(for key: RemoteConfigKey) async throws -> String {
        ""
    }
}
