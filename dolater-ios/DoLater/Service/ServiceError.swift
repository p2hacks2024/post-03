//
//  ServiceError.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Foundation

enum ServiceError: LocalizedError {
    case account(AccountServiceError)
    case task(TaskServiceError)

    var errorDescription: String? {
        switch self {
        case .account(let error):
            "Account Service Error: \(error.localizedDescription)"

        case .task(let error):
            "Task Service Error: \(error.localizedDescription)"
        }
    }
}
