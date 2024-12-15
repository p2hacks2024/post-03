//
//  HTTPRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import Foundation

protocol HTTPRepositoryProtocol: Actor {
    func get(for url: URL) async throws -> Data
}

final actor HTTPRepositoryImpl: HTTPRepositoryProtocol {
    func get(for url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse else {
            throw RepositoryError.http(.failedToGetHTTPURLResponse)
        }
        guard (200..<300).contains(response.statusCode) else {
            throw RepositoryError.server(.init(rawValue: response.statusCode), nil)
        }
        return data
    }
}
