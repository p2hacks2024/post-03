//
//  RepositoryError.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Foundation

enum RepositoryError: LocalizedError {
    enum HTTPStatus: RawRepresentable, CaseIterable, Hashable, Sendable {
        case badRequest
        case unauthorized
        case forbidden
        case notFound
        case methodNotAllowed
        case internalServerError
        case notImplemented
        case badGateway
        case serviceUnavailable
        case other(Int)

        static let allCases: [HTTPStatus] = [
            .badRequest,
            .unauthorized,
            .forbidden,
            .notFound,
            .methodNotAllowed,
            .internalServerError,
            .notImplemented,
            .badGateway,
            .serviceUnavailable,
        ]

        var rawValue: Int {
            switch self {
            case .badRequest:
                400
            case .unauthorized:
                401
            case .forbidden:
                403
            case .notFound:
                404
            case .methodNotAllowed:
                405
            case .internalServerError:
                500
            case .notImplemented:
                501
            case .badGateway:
                502
            case .serviceUnavailable:
                503
            case .other(let code):
                code
            }
        }

        var description: String {
            switch self {
            case .badRequest:
                "Bad Request"
            case .unauthorized:
                "Unauthorized"
            case .forbidden:
                "Forbidden"
            case .notFound:
                "Not Found"
            case .methodNotAllowed:
                "Method Not Allowed"
            case .internalServerError:
                "Internal Server Error"
            case .notImplemented:
                "Not Implemented"
            case .badGateway:
                "Bad Gateway"
            case .serviceUnavailable:
                "Service Unavailable"
            case .other(let code):
                code.description
            }
        }

        init(rawValue: Int) {
            self = HTTPStatus.allCases.first(where: { $0.rawValue == rawValue }) ?? .other(rawValue)
        }
    }

    case invalidResponseBody((any Sendable & Hashable)?)
    case server(HTTPStatus, (any Sendable & Hashable)?)
    case account(AuthRepositoryError)
    case http(HTTPRepositoryError)
    case local(LocalRepositoryError)
    case unknown(Error?)

    var errorDescription: String? {
        switch self {
        case .server(let code, let payload):
            "Server error: \(code.rawValue) \(code.description): \(payload ?? "")"
        case .invalidResponseBody(let body):
            "Invalid response: \(body ?? "")"
        case .account(let error):
            "Account Repository error: \(error.localizedDescription)"
        case .http(let error):
            "HTTP Repository error: \(error.localizedDescription)"
        case .local(let error):
            "Local Repository error: \(error.localizedDescription)"
        case .unknown(let error):
            "Unknown error: \(error.debugDescription)"
        }
    }
}
