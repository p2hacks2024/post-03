//
//  TaskServiceError.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import Foundation

enum TaskServiceError: LocalizedError {
    case failedToGetURLComponents
    case failedToConvertStringToURL
    case failedToConvertData
    case failedToGetTitle

    var errorDescription: String? {
        switch self {
        case .failedToGetURLComponents:
            "Failed to get URL components."

        case .failedToConvertStringToURL:
            "Failed to convert string to URL."

        case .failedToConvertData:
            "Failed to convert data."

        case .failedToGetTitle:
            "Failed to get title."
        }
    }
}
