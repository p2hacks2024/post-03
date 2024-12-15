//
//  HTTPRepositoryError.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import Foundation

enum HTTPRepositoryError: LocalizedError {
    case failedToGetHTTPURLResponse

    var errorDescription: String? {
        switch self {
        case .failedToGetHTTPURLResponse:
            return "Failed to get HTTP URL response."
        }
    }
}
