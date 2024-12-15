//
//  HTTPMetadata.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/12/24.
//

import Foundation

enum HTTPMetadata<Environment: EnvironmentImpl> {
    static func getPageTitle(for url: URL) async throws -> String {
        let data = try await Environment.shared.httpRepository.get(for: url)
        guard let content = String(data: data, encoding: .utf8) else {
            throw TaskServiceError.failedToConvertData
        }
        guard
            let range = content.range(
            of: "<title>.*?</title>",
            options: .regularExpression
        )
        else {
            throw TaskServiceError.failedToGetTitle
        }
        let title = content[range].replacingOccurrences(of: "</?title>", with: "", options: .regularExpression)
        return title
    }
}
