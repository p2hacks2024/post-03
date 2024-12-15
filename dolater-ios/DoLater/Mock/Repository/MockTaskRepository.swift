//
//  MockTaskRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/10/24.
//

final actor MockTaskRepository: TaskRepositoryProtocol {
    init() {}

    func getTasks(poolId: Components.Parameters.poolId?, friendHas: Components.Parameters.friendHas?) async throws -> [Components.Schemas.Task] {
        if friendHas ?? false {
            return Components.Schemas.Task.mocks.filter { task in
                task.owner.id != Components.Schemas.User.mock1.id
            }
        }
        if let poolId {
            return Components.Schemas.Task.mocks.filter { task in
                task.pool.id == poolId
            }
        }
        return Components.Schemas.Task.mocks
    }

    func createTask(_ task: Components.Schemas.CreateTaskInput) async throws
        -> Components.Schemas.Task
    {
        .mock1
    }

    func getTask(id: Components.Parameters.id) async throws -> Components.Schemas.Task {
        .mock1
    }

    func updateTask(_ task: Components.Schemas.UpdateTaskInput, id: Components.Parameters.id)
        async throws -> Components.Schemas.Task
    {
        var updatedTask = Components.Schemas.Task.mock1
        if let url = task.url {
            updatedTask.url = url
        }
        if let archivedAt = task.archivedAt {
            updatedTask.archivedAt = archivedAt
        }
        if let completedAt = task.completedAt {
            updatedTask.completedAt = completedAt
        }
        if let poolId = task.poolId {
            updatedTask.pool.id = poolId
        }
        return updatedTask
    }

    func updateTaskForcibly(_ task: Components.Schemas.UpdateTaskInput, id: Components.Parameters.id)
    async throws -> Components.Schemas.Task {
        var updatedTask = Components.Schemas.Task.mock1
        if let url = task.url {
            updatedTask.url = url
        }
        updatedTask.archivedAt = task.archivedAt
        updatedTask.completedAt = task.completedAt
        if let poolId = task.poolId {
            updatedTask.pool.id = poolId
        }
        return updatedTask
    }

    func deleteTask(id: Components.Parameters.id) async throws {
    }
}
