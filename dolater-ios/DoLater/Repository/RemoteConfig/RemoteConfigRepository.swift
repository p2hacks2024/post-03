//
//  RemoteConfigRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import FirebaseRemoteConfig

protocol RemoteConfigRepositoryProtocol: Actor {
    func fetchBool(for key: RemoteConfigKey) async throws -> Bool

    func fetchData(for key: RemoteConfigKey) async throws -> Data

    func fetchDouble(for key: RemoteConfigKey) async throws -> Double

    func fetchInt(for key: RemoteConfigKey) async throws -> Int

    func fetchString(for key: RemoteConfigKey) async throws -> String
}

final actor RemoteConfigRepositoryImpl: RemoteConfigRepositoryProtocol {
    nonisolated(unsafe) private let remoteConfig: RemoteConfig

    init() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
    }

    func fetchBool(for key: RemoteConfigKey) async throws -> Bool {
        try await remoteConfig.fetchAndActivate()
        return remoteConfig.configValue(forKey: key.name).boolValue
    }

    func fetchData(for key: RemoteConfigKey) async throws -> Data {
        try await remoteConfig.fetchAndActivate()
        return remoteConfig.configValue(forKey: key.name).dataValue
    }

    func fetchDouble(for key: RemoteConfigKey) async throws -> Double {
        try await remoteConfig.fetchAndActivate()
        return remoteConfig.configValue(forKey: key.name).numberValue.doubleValue
    }

    func fetchInt(for key: RemoteConfigKey) async throws -> Int {
        try await remoteConfig.fetchAndActivate()
        return remoteConfig.configValue(forKey: key.name).numberValue.intValue
    }

    func fetchString(for key: RemoteConfigKey) async throws -> String {
        try await remoteConfig.fetchAndActivate()
        return remoteConfig.configValue(forKey: key.name).stringValue
    }
}
