//
//  Servers+.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Foundation

enum ServerEnvironment: String, CaseIterable, Identifiable {
    case production
    case staging
    case development
    case local

    var id: Self { self }

    var apiServerURL: URL {
        do {
            switch self {
            case .production:
                return try Servers.Server1.url()

            case .staging:
                return try Servers.Server2.url()

            case .development:
                return try Servers.Server3.url()

            case .local:
                return try Servers.Server4.url()
            }
        } catch {
            return URL(string: "http://localhost:8080")!
        }
    }
}
