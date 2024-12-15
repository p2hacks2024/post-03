//
//  TaskPresenterError.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/13/24.
//

import Foundation

enum TaskPresenterError: LocalizedError {
    case invalidURL

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "有効なURLを入力してください"
        }
    }
}
