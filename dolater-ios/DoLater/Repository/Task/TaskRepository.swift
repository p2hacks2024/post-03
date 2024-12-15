//
//  TaskRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/10/24.
//

protocol TaskRepositoryProtocol: Actor {
    func getTasks(
        poolId: Components.Parameters.poolId?,
        friendHas: Components.Parameters.friendHas?
    ) async throws -> [Components.Schemas.Task]

    func createTask(
        _ task: Components.Schemas.CreateTaskInput
    ) async throws -> Components.Schemas.Task

    func getTask(id: Components.Parameters.id) async throws -> Components.Schemas.Task

    func updateTask(
        _ task: Components.Schemas.UpdateTaskInput,
        id: Components.Parameters.id
    ) async throws -> Components.Schemas.Task

    func updateTaskForcibly(
        _ task: Components.Schemas.UpdateTaskInput,
        id: Components.Parameters.id
    ) async throws -> Components.Schemas.Task

    func deleteTask(id: Components.Parameters.id) async throws
}

final actor TaskRepositoryImpl: TaskRepositoryProtocol {
    init() {}

    func getTasks(
        poolId: Components.Parameters.poolId?,
        friendHas: Components.Parameters.friendHas?
    ) async throws -> [Components.Schemas.Task] {
        do {
            let client = try await Client.build()
            let response = try await client.getTasks(
                query: .init(
                    poolId: poolId,
                    friendHas: friendHas
                )
            )
            switch response {
            case .ok(let okResponse):
                if case let .json(tasks) = okResponse.body {
                    return tasks
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

    func createTask(_ task: Components.Schemas.CreateTaskInput) async throws
        -> Components.Schemas.Task
    {
        do {
            let client = try await Client.build()
            let response = try await client.createTask(body: .json(task))
            switch response {
            case .created(let okResponse):
                if case let .json(task) = okResponse.body {
                    return task
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

    func getTask(id: Components.Parameters.id) async throws -> Components.Schemas.Task {
        do {
            let client = try await Client.build()
            let response = try await client.getTask(path: .init(id: id))
            switch response {
            case .ok(let okResponse):
                if case let .json(task) = okResponse.body {
                    return task
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

    func updateTask(_ task: Components.Schemas.UpdateTaskInput, id: Components.Parameters.id)
        async throws -> Components.Schemas.Task
    {
        do {
            let client = try await Client.build()
            let response = try await client.updateTask(
                path: .init(id: id),
                body: .json(task)
            )
            switch response {
            case .ok(let okResponse):
                if case let .json(task) = okResponse.body {
                    return task
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

    func updateTaskForcibly(_ task: Components.Schemas.UpdateTaskInput, id: Components.Parameters.id)
        async throws -> Components.Schemas.Task
    {
        do {
            let client = try await Client.build()
            let response = try await client.updateTaskForcibly(
                path: .init(id: id),
                body: .json(task)
            )
            switch response {
            case .ok(let okResponse):
                if case let .json(task) = okResponse.body {
                    return task
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

    func deleteTask(id: Components.Parameters.id) async throws {
        do {
            let client = try await Client.build()
            let response = try await client.deleteTask(path: .init(id: id))
            switch response {
            case .noContent:
                return

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
