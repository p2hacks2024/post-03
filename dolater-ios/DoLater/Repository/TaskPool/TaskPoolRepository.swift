//
//  TaskPoolRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/10/24.
//

protocol TaskPoolRepositoryProtocol: Actor {
    func getPools() async throws -> [Components.Schemas.TaskPool]

    func getPool(id: Components.Parameters.id) async throws -> Components.Schemas.TaskPool
}

final actor TaskPoolRepositoryImpl: TaskPoolRepositoryProtocol {
    init() {}

    func getPools() async throws -> [Components.Schemas.TaskPool] {
        do {
            let client = try await Client.build()
            let response = try await client.getPools()
            switch response {
            case .ok(let okResponse):
                if case let .json(pools) = okResponse.body {
                    return pools
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

    func getPool(id: Components.Parameters.id) async throws -> Components.Schemas.TaskPool {
        do {
            let client = try await Client.build()
            let response = try await client.getPool(path: .init(id: id))
            switch response {
            case .ok(let okResponse):
                if case let .json(pool) = okResponse.body {
                    return pool
                }
                throw RepositoryError.invalidResponseBody(okResponse.body)

            case .unauthorized(let errorResponse):
                if case let .json(error) = errorResponse.body {
                    throw RepositoryError.server(.unauthorized, error.message)
                }
                throw RepositoryError.server(.unauthorized, nil)

            case .notFound(let errorResponse):
                if case let .json(error) = errorResponse.body {
                    throw RepositoryError.server(.notFound, error.message)
                }
                throw RepositoryError.server(.notFound, nil)

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
