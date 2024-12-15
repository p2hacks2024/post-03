//
//  LocalRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Foundation

protocol LocalRepositoryProtocol: Actor {
    func getBool(for key: UserDefaultsKey) async throws -> Bool

    func getData(for key: UserDefaultsKey) async throws -> Data

    func getInt(for key: UserDefaultsKey) async throws -> Int

    func getString(for key: UserDefaultsKey) async throws -> String

    func setBool(_ value: Bool, for key: UserDefaultsKey) async throws

    func setData(_ value: Data, for key: UserDefaultsKey) async throws

    func setInt(_ value: Int, for key: UserDefaultsKey) async throws

    func setString(_ value: String, for key: UserDefaultsKey) async throws

    func remove(for key: UserDefaultsKey) async throws
}

final actor LocalRepositoryImpl: LocalRepositoryProtocol {
    init() {}

    func getBool(for key: UserDefaultsKey) async throws -> Bool {
        guard let userDefaults = UserDefaults.group else {
            throw LocalRepositoryError.unavailable
        }
        return userDefaults.bool(forKey: key.name)
    }

    func getData(for key: UserDefaultsKey) async throws -> Data {
        guard let userDefaults = UserDefaults.group else {
            throw LocalRepositoryError.unavailable
        }
        guard let value = userDefaults.data(forKey: key.name) else {
            throw LocalRepositoryError.nilValue
        }
        return value
    }

    func getInt(for key: UserDefaultsKey) async throws -> Int {
        guard let userDefaults = UserDefaults.group else {
            throw LocalRepositoryError.unavailable
        }
        return userDefaults.integer(forKey: key.name)
    }

    func getString(for key: UserDefaultsKey) async throws -> String {
        guard let userDefaults = UserDefaults.group else {
            throw LocalRepositoryError.unavailable
        }
        guard let value = userDefaults.string(forKey: key.name) else {
            throw LocalRepositoryError.nilValue
        }
        return value
    }

    func setBool(_ value: Bool, for key: UserDefaultsKey) async throws {
        guard let userDefaults = UserDefaults.group else {
            throw LocalRepositoryError.unavailable
        }
        userDefaults.set(value, forKey: key.name)
    }

    func setData(_ value: Data, for key: UserDefaultsKey) async throws {
        guard let userDefaults = UserDefaults.group else {
            throw LocalRepositoryError.unavailable
        }
        userDefaults.set(value, forKey: key.name)
    }

    func setInt(_ value: Int, for key: UserDefaultsKey) async throws {
        guard let userDefaults = UserDefaults.group else {
            throw LocalRepositoryError.unavailable
        }
        userDefaults.set(value, forKey: key.name)
    }

    func setString(_ value: String, for key: UserDefaultsKey) async throws {
        guard let userDefaults = UserDefaults.group else {
            throw LocalRepositoryError.unavailable
        }
        userDefaults.set(value, forKey: key.name)
    }

    func remove(for key: UserDefaultsKey) async throws {
        guard let userDefaults = UserDefaults.group else {
            throw LocalRepositoryError.unavailable
        }
        userDefaults.removeObject(forKey: key.name)
    }
}
