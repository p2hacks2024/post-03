//
//  TaskService.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import Foundation
import SwiftUI

final actor TaskService<Environment: EnvironmentProtocol> {
    init() {}

    func getActiveTasks() async throws -> [DLTask] {
        let taskPools = try await Environment.shared.taskPoolRepository.getPools()
        guard let activePool = taskPools.first(where: { $0._type == .taskPoolTypeActive }) else {
            return []
        }
        let tasks = try await Environment.shared.taskRepository.getTasks(poolId: activePool.id, friendHas: nil)
        return tasks.sorted { $0.createdAt > $1.createdAt }
    }

    func getActiveTasks(id: String) async throws -> [DLTask] {
        let taskPools = try await Environment.shared.taskPoolRepository.getPools()
        guard let activePool = taskPools.first(where: { $0._type == .taskPoolTypeActive }) else {
            return []
        }
        let tasks = try await Environment.shared.taskRepository.getTasks(poolId: activePool.id, friendHas: nil)
        return tasks.sorted { $0.createdAt > $1.createdAt }
    }

    func getRemovedTasks() async throws -> [DLTask] {
        let taskPools = try await Environment.shared.taskPoolRepository.getPools()
        guard let binPool = taskPools.first(where: { $0._type == .taskPoolTypeBin }) else {
            return []
        }
        return try await Environment.shared.taskRepository.getTasks(poolId: binPool.id, friendHas: nil)
    }

    func getArchivedTasks() async throws -> [DLTask] {
        let taskPools = try await Environment.shared.taskPoolRepository.getPools()
        guard let binPool = taskPools.first(where: { $0._type == .taskPoolTypeArchived }) else {
            return []
        }
        return try await Environment.shared.taskRepository.getTasks(poolId: binPool.id, friendHas: nil)
    }

    func getPendingTasks() async throws -> [DLTask] {
        let taskPools = try await Environment.shared.taskPoolRepository.getPools()
        guard let binPool = taskPools.first(where: { $0._type == .taskPoolTypePending }) else {
            return []
        }
        return try await Environment.shared.taskRepository.getTasks(poolId: binPool.id, friendHas: nil)
    }

    func getTasksFriendHas() async throws -> [DLTask] {
        try await Environment.shared.taskRepository.getTasks(poolId: nil, friendHas: true)
    }

    func get(id: String) async throws -> DLTask {
        try await Environment.shared.taskRepository.getTask(id: id)
    }

    func add(url: URL) async throws -> DLTask {
        try await Environment.shared.taskRepository.createTask(.init(url: url.absoluteString))
    }

    func markAsCompleted(taskId: String) async throws -> DLTask {
        try await Environment.shared.taskRepository.updateTask(
            .init(completedAt: .now),
            id: taskId
        )
    }

    func markAsToDo(id: String) async throws -> DLTask {
        let task = try await Environment.shared.taskRepository.getTask(id: id)
        return try await Environment.shared.taskRepository.updateTaskForcibly(
            .init(
                url: task.url,
                completedAt: nil,
                archivedAt: task.archivedAt,
                poolId: task.pool.id
            ),
            id: id
        )
    }

    func remove(id: String) async throws -> DLTask? {
        let taskPools = try await Environment.shared.taskPoolRepository.getPools()
        guard let binPool = taskPools.first(where: { $0._type == .taskPoolTypeBin }) else {
            return nil
        }
        return try await Environment.shared.taskRepository.updateTask(
            .init(
                removedAt: .now,
                poolId: binPool.id
            ),
            id: id
        )
    }

    func archive() async throws -> [DLTask] {
        let tasks = try await getRemovedTasks()
        return await withTaskGroup(of: DLTask?.self, returning: [DLTask].self) { group in
            tasks.forEach { task in
                group.addTask {
                    try? await Environment.shared.taskRepository.updateTask(
                        .init(removedAt: .now),
                        id: task.id
                    )
                }
            }
            var result: [DLTask?] = []
            for await task in group {
                result.append(task)
            }
            let successfulTaskIds = result.compactMap({ $0?.id })
            return tasks.filter { task in
                !successfulTaskIds.contains(task.id)
            }
        }
    }

    func archive(id: String) async throws -> DLTask {
        try await Environment.shared.taskRepository.updateTask(
            .init(removedAt: .now),
            id: id
        )
    }

    func delete(taskId: String) async throws {
        try await Environment.shared.taskRepository.deleteTask(id: taskId)
    }
}
