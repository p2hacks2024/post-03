//
//  MockLocalRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Foundation

final actor MockLocalRepository: LocalRepositoryProtocol {
    init() {}

    func getBool(for key: UserDefaultsKey) async throws -> Bool {
        false
    }

    func getData(for key: UserDefaultsKey) async throws -> Data {
        .init()
    }

    func getInt(for key: UserDefaultsKey) async throws -> Int {
        0
    }

    func getString(for key: UserDefaultsKey) async throws -> String {
        ""
    }

    func setBool(_ value: Bool, for key: UserDefaultsKey) async throws {
    }

    func setData(_ value: Data, for key: UserDefaultsKey) async throws {
    }

    func setInt(_ value: Int, for key: UserDefaultsKey) async throws {
    }

    func setString(_ value: String, for key: UserDefaultsKey) async throws {
    }

    func remove(for key: UserDefaultsKey) async throws {
    }
}
