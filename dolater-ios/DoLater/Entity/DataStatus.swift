//
//  DataStatus.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Foundation

enum DataStatus: RawRepresentable, Hashable, Sendable {
    case `default`
    case loading
    case loaded
    case failed(DomainError)

    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }

    var isFailed: Bool {
        if case .failed = self {
            return true
        }
        return false
    }

    var domainError: DomainError? {
        if case .failed(let error) = self {
            return error
        }
        return nil
    }

    var rawValue: Int {
        switch self {
        case .default: 0
        case .loading: 1
        case .loaded: 2
        case .failed: 3
        }
    }

    init(rawValue: Int) {
        self =
            switch rawValue {
            case 0: .default
            case 1: .loading
            case 2: .loaded
            case 3: .failed(.unknown(nil))
            default: .default
            }
    }
}
