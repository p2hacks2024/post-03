//
//  NotificationRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import FirebaseMessaging
import Foundation
import OpenAPIURLSession

protocol NotificationRepositoryProtocol: Actor {
    func getFCMToken() async throws -> String

    func postFCMToken(_ token: String) async throws

    func getNotifications() async throws -> [Components.Schemas.Notification]
}

final actor NotificationRepositoryImpl: NotificationRepositoryProtocol {
    init() {}

    func getFCMToken() async throws -> String {
        try await Messaging.messaging().token()
    }

    func postFCMToken(_ token: String) async throws {
        do {
            let client = try await Client.build()
            let response = try await client.upsertFCMToken(
                .init(body: .json(.init(token: token)))
            )
            switch response {
            case .noContent:
                return

            case .unauthorized(let errorResponse):
                if case let .json(error) = errorResponse.body {
                    throw RepositoryError.server(.unauthorized, error.message)
                }
                throw RepositoryError.server(.unauthorized, nil)

            case .internalServerError(let errorResponse):
                if case let .json(error) = errorResponse.body {
                    throw RepositoryError.server(.internalServerError, error.message)
                }
                throw RepositoryError.server(.internalServerError, nil)

            case .undocumented(let statusCode, let payload):
                throw RepositoryError.server(.init(rawValue: statusCode), payload)
            }
        } catch let error as RepositoryError {
            Logger.standard.error("RepositoryError: \(error.localizedDescription)")
            throw error
        } catch {
            Logger.standard.error("RepositoryError: \(error)")
            throw error
        }
    }

    func getNotifications() async throws -> [Components.Schemas.Notification] {
        do {
            let client = try await Client.build()
            let response = try await client.getNotifications()
            switch response {
            case .ok(let okResponse):
                if case let .json(notifications) = okResponse.body {
                    return notifications
                }
                throw RepositoryError.invalidResponseBody(okResponse.body)

            case .unauthorized(let errorResponse):
                if case let .json(error) = errorResponse.body {
                    throw RepositoryError.server(.unauthorized, error.message)
                }
                throw RepositoryError.server(.unauthorized, nil)

            case .internalServerError(let errorResponse):
                if case let .json(error) = errorResponse.body {
                    throw RepositoryError.server(.internalServerError, error.message)
                }
                throw RepositoryError.server(.internalServerError, nil)

            case .undocumented(let statusCode, let payload):
                throw RepositoryError.server(.init(rawValue: statusCode), payload)
            }
        } catch let error as RepositoryError {
            Logger.standard.error("RepositoryError: \(error.localizedDescription)")
            throw error
        } catch {
            Logger.standard.error("RepositoryError: \(error)")
            throw error
        }
    }
}
