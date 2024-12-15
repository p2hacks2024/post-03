//
//  PresenterError.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/13/24.
//

import Foundation

enum PresenterError: LocalizedError {
    case invalidAppVersion
    case task(TaskPresenterError)

    var errorDescription: String? {
        switch self {
        case .invalidAppVersion:
            String(localized: "This app version is not supported")
        case .task(let error):
            error.localizedDescription
        }
    }
}
