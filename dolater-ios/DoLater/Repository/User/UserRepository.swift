//
//  UserRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/10/24.
//

protocol UserRepositoryProtocol: Actor {
    func getUsers() async throws -> [Components.Schemas.User]

    func createUser() async throws -> Components.Schemas.User

    func getUser(id: Components.Parameters.uid) async throws -> Components.Schemas.User

    func updateUser(_ user: Components.Schemas.UpdateUserInput, id: Components.Parameters.uid)
    async throws -> Components.Schemas.User

    func deleteUser(id: Components.Parameters.uid) async throws

    func getFollowings(id: Components.Parameters.uid) async throws -> [Components.Schemas.User]

    func getFollowers(id: Components.Parameters.uid) async throws -> [Components.Schemas.User]

    func getFriends(id: Components.Parameters.uid) async throws -> [Components.Schemas.User]

    func followUser(id: Components.Parameters.uid) async throws -> Components.Schemas.FollowStatus

    func unfollowUser(id: Components.Parameters.uid) async throws
}

final actor UserRepositoryImpl: UserRepositoryProtocol {
    init() {}

    func getUsers() async throws -> [Components.Schemas.User] {
        do {
            let client = try await Client.build()
            let response = try await client.getUsers()
            switch response {
            case .ok(let okResponse):
                if case let .json(users) = okResponse.body {
                    return users
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

    func createUser() async throws -> Components.Schemas.User {
        do {
            let client = try await Client.build()
            let response = try await client.createUser()
            switch response {
            case .created(let okResponse):
                if case let .json(user) = okResponse.body {
                    return user
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

    func getUser(id: Components.Parameters.uid) async throws -> Components.Schemas.User {
        do {
            let client = try await Client.build()
            let response = try await client.getUser(path: .init(uid: id))
            switch response {
            case .ok(let okResponse):
                if case let .json(users) = okResponse.body {
                    return users
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

    func updateUser(_ user: Components.Schemas.UpdateUserInput, id: Components.Parameters.uid)
    async throws -> Components.Schemas.User
    {
        do {
            let client = try await Client.build()
            let response = try await client.updateUser(
                path: .init(uid: id),
                body: .json(user)
            )
            switch response {
            case .ok(let okResponse):
                if case let .json(users) = okResponse.body {
                    return users
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

    func deleteUser(id: Components.Parameters.uid) async throws {
        do {
            let client = try await Client.build()
            let response = try await client.deleteUser(path: .init(uid: id))
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

    func getFollowings(id: Components.Parameters.uid) async throws -> [Components.Schemas.User] {
        do {
            let client = try await Client.build()
            let response = try await client.getFollowings(path: .init(uid: id))
            switch response {
            case .ok(let okResponse):
                if case let .json(users) = okResponse.body {
                    return users
                }
                throw RepositoryError.invalidResponseBody(okResponse.body)

            case .unauthorized(let errorResponse):
                if case let .json(error) = errorResponse.body {
                    throw RepositoryError.server(.unauthorized, error.message)
                }
                throw RepositoryError.server(.unauthorized, nil)

                //case .notFound(let errorResponse):
                //    if case let .json(error) = errorResponse.body {
                //        throw RepositoryError.server(.notFound, error.message)
                //    }
                //    throw RepositoryError.server(.notFound, nil)

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

    func getFollowers(id: Components.Parameters.uid) async throws -> [Components.Schemas.User] {
        do {
            let client = try await Client.build()
            let response = try await client.getFollowers(path: .init(uid: id))
            switch response {
            case .ok(let okResponse):
                if case let .json(users) = okResponse.body {
                    return users
                }
                throw RepositoryError.invalidResponseBody(okResponse.body)

            case .unauthorized(let errorResponse):
                if case let .json(error) = errorResponse.body {
                    throw RepositoryError.server(.unauthorized, error.message)
                }
                throw RepositoryError.server(.unauthorized, nil)

                //case .notFound(let errorResponse):
                //    if case let .json(error) = errorResponse.body {
                //        throw RepositoryError.server(.notFound, error.message)
                //    }
                //    throw RepositoryError.server(.notFound, nil)

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

    func getFriends(id: Components.Parameters.uid) async throws -> [Components.Schemas.User] {
        do {
            let client = try await Client.build()
            let response = try await client.getFriends(path: .init(uid: id))
            switch response {
            case .ok(let okResponse):
                if case let .json(users) = okResponse.body {
                    return users
                }
                throw RepositoryError.invalidResponseBody(okResponse.body)

            case .unauthorized(let errorResponse):
                if case let .json(error) = errorResponse.body {
                    throw RepositoryError.server(.unauthorized, error.message)
                }
                throw RepositoryError.server(.unauthorized, nil)

                //case .notFound(let errorResponse):
                //    if case let .json(error) = errorResponse.body {
                //        throw RepositoryError.server(.notFound, error.message)
                //    }
                //    throw RepositoryError.server(.notFound, nil)

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

    func followUser(id: Components.Parameters.uid) async throws -> Components.Schemas.FollowStatus {
        do {
            let client = try await Client.build()
            let response = try await client.followUser(path: .init(uid: id))
            switch response {
            case .ok(let okResponse):
                if case let .json(followStatus) = okResponse.body {
                    return followStatus
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

    func unfollowUser(id: Components.Parameters.uid) async throws {
        do {
            let client = try await Client.build()
            let response = try await client.unfollowUser(path: .init(uid: id))
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
