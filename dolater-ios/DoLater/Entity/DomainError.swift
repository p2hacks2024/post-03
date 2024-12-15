//
//  CommonError.swift
//  DoLater
//
//  //  Created by Kanta Oikawa on 12/8/24..
//

import Foundation

enum DomainError: LocalizedError {
    case presenter(PresenterError)
    case service(ServiceError)
    case repository(RepositoryError)
    case unknown(Error?)

    var errorDescription: String? {
        switch self {
        case .presenter(let error):
            error.errorDescription

        case .service(let error):
            switch error {
            case .account:
                "Something went wrong with account"
            case .task:
                "Something went wrong with task"
            }
        case .repository(let error):
            switch error {
            case .invalidResponseBody:
                "Unexpected server response"
            case .server:
                "Something went wrong with the server"
            case .account:
                "Something went wrong with the account"
            case .http:
                "Something went wrong with the HTTP request"
            case .local:
                "Something went wrong with the User Defaults"
            case .unknown:
                "Something went wrong"
            }
        case .unknown:
            "Some thing went wrong"
        }
    }

    var detail: String {
        switch self {
        case .presenter(let error):
            error.localizedDescription
        case .service(let error):
            error.localizedDescription
        case .repository(let error):
            switch error {
            case .invalidResponseBody:
                "Received unexpected response from the server."
            case .server(let status, _):
                switch status {
                case .badRequest:
                    "Bad request has been made."
                case .unauthorized:
                    "Failed to be authenticated."
                case .forbidden:
                    "Failed to be authorized."
                case .notFound:
                    "The resource was not found."
                case .methodNotAllowed:
                    "The requested method is not allowed."
                case .internalServerError:
                    "A server error has occurred."
                case .notImplemented:
                    "The server doesn't implement the method."
                case .badGateway:
                    "The gateway error has occurred."
                case .serviceUnavailable:
                    "The server is temporarily unavailable."
                case .other:
                    "Unexpected error has occurred."
                }
            case .account(let error):
                error.localizedDescription
            case .http(let error):
                error.localizedDescription
            case .local(let error):
                error.localizedDescription
            case .unknown:
                "Unexpected error has occurred."
            }
        case .unknown:
            "Unexpected error has occurred."
        }
    }

    init(_ error: Error) {
        if let error = error as? ServiceError {
            self = .service(error)
            return
        }
        if let error = error as? RepositoryError {
            self = .repository(error)
            return
        }
        self = .unknown(error)
    }
}
