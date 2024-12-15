//
//  LocalRepositoryError.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Foundation

enum LocalRepositoryError: LocalizedError {
    case unavailable
    case nilValue

    var errorDescription: String? {
        switch self {
        case .unavailable:
            return "User Defaults group is unavailable"

        case .nilValue:
            return "The value is nil"
        }
    }
}
