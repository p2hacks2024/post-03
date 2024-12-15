//
//  HTTPRepositoryTests.swift
//  DoLaterTests
//
//  Created by Kanta Oikawa on 12/11/24.
//

import Foundation
import Testing

@testable import DoLater

struct HTTPRepositoryTests {
    private let repository = HTTPRepositoryImpl()

    @Test func testGet() async throws {
        let urlString = "https://developer.apple.com/documentation/swiftui"
        let urlComponents = URLComponents(string: urlString)!
        let faviconURLString = urlComponents.scheme?.appending("://").appending(urlComponents.host ?? "").appending("/favicon.ico") ?? ""
        #expect(faviconURLString == "https://developer.apple.com/favicon.ico")

        _ = try await repository.get(for: .init(string: faviconURLString)!)
        _ = try await repository.get(for: .init(string: urlString)!)
    }
}
