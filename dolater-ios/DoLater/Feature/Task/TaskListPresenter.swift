//
//  TaskListPresenter.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/12/24.
//

import Observation
import SwiftUI

@Observable
final class TaskListPresenter<Environment: EnvironmentProtocol>: PresenterProtocol {
    struct State: Equatable {
        var path: NavigationPath

        var scene: TaskListScene<Environment>
        var activeTasks: [DLTask] = []
        var renderedTasks: [DLTask] = []
        var removedTasks: [DLTask] = []
        var isAddTaskDialogPresented: Bool = false
        var isBinPresented: Bool = false

        var isSpriteKitDebugMode: Bool = false

        var getActiveTasksStatus: DataStatus = .default
        var getRemovedTasksStatus: DataStatus = .default
        var updateTaskStatus: DataStatus = .default
        var addTaskStatus: DataStatus = .default

        var renderingTasks: [DLTask] {
            activeTasks.sorted { $0.createdAt > $1.createdAt }
        }

        enum Path: Hashable {
            case detail(DLTask)
            case preview(DLTask)
        }
    }

    enum Action {
        case onAppear
        case onTasksDropped([DLTask], CGPoint)
        case onBinTapped
        case onTaskTapped(DLTask)
        case onMarkAsCompletedButtonTapped(DLTask)
        case onMarkAsToDoButtonTapped(DLTask)
        case onDeleteButtonTapped(DLTask)
        case onAddTaskConfirmed(String)
    }

    var state: State

    private let debugService: DebugService<Environment> = .init()
    private let taskService: TaskService<Environment> = .init()

    init(path: NavigationPath) {
        let scene = TaskListScene<Environment>()
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .clear
        state = .init(path: path, scene: scene)
    }

    func dispatch(_ action: Action) {
        Task {
            await dispatch(action)
        }
    }

    func dispatch(_ action: Action) async {
        switch action {
        case .onAppear:
            await onAppear()

        case .onTasksDropped(let droppedTasks, let droppedPoint):
            await onTasksDropped(droppedTasks, at: droppedPoint)

        case .onBinTapped:
            await onBinTapped()

        case .onTaskTapped(let task):
            await onTaskTapped(task)

        case .onMarkAsCompletedButtonTapped(let task):
            await onMarkAsCompletedButtonTapped(task)

        case .onMarkAsToDoButtonTapped(let task):
            await onMarkAsToDoButtonTapped(task)

        case .onDeleteButtonTapped(let task):
            await onDeleteButtonTapped(task)

        case .onAddTaskConfirmed(let text):
            await onAddTaskConfirmed(text: text)
        }
    }
}

private extension TaskListPresenter {
    func onAppear() async {
        do {
            state.getActiveTasksStatus = .loading
            state.activeTasks = try await taskService.getActiveTasks()
            if state.activeTasks != state.renderedTasks {
                await refreshNodes()
            }
            state.getActiveTasksStatus = .loaded
        } catch {
            state.getActiveTasksStatus = .failed(.init(error))
        }

        do {
            state.getRemovedTasksStatus = .loading
            state.removedTasks = try await taskService.getRemovedTasks()
            state.getRemovedTasksStatus = .loaded
        } catch {
            state.getRemovedTasksStatus = .failed(.init(error))
        }

        state.isSpriteKitDebugMode = await debugService.getSpriteKitDebugMode()
    }

    func onTasksDropped(_ droppedTasks: [DLTask], at droppedPoint: CGPoint) async {
        let removingTasks = droppedTasks.filter { task in
            if !task.isCompleted {
                return false
            }
            if task.owner.id != task.pool.owner?.id {
                return false
            }
            return true
        }
        let removingTaskIds = removingTasks.map { $0.id }
        state.activeTasks.removeAll { task in
            removingTaskIds.contains(task.id)
        }
        var successfullyRemovedTasks: [DLTask?] = []
        for task in droppedTasks {
            do {
                state.updateTaskStatus = .loading
                let updatedTask = try await taskService.remove(id: task.id)
                successfullyRemovedTasks.append(updatedTask)
                state.updateTaskStatus = .loaded
            } catch {
                state.updateTaskStatus = .failed(.init(error))
            }
        }
        let nodes = successfullyRemovedTasks.compactMap { task in
            state.scene.childNode(withName: task?.displayName ?? "")
        }
        state.scene.removeChildren(in: nodes)
        let successfullyRemovedTaskIds = successfullyRemovedTasks.compactMap { $0?.id }
        let failedToRemoveTasks = removingTasks.filter { !successfullyRemovedTaskIds.contains($0.id) }
        state.removedTasks.append(contentsOf: failedToRemoveTasks)
    }

    func onBinTapped() async {
        state.isBinPresented = true
    }

    func onTaskTapped(_ task: DLTask) async {
        if task.owner.id == task.pool.owner?.id {
            state.path.append(State.Path.detail(task))
        } else {
            state.path.append(State.Path.preview(task))
        }
    }

    func onMarkAsCompletedButtonTapped(_ task: DLTask) async {
        do {
            state.updateTaskStatus = .loading
            let updatedTask = try await taskService.markAsCompleted(taskId: task.id)
            state.activeTasks.removeAll(where: { $0.id == task.id })
            state.activeTasks.append(updatedTask)
            state.updateTaskStatus = .loaded
        } catch {
            state.updateTaskStatus = .failed(.init(error))
        }
    }

    func onMarkAsToDoButtonTapped(_ task: DLTask) async {
        do {
            state.updateTaskStatus = .loading
            let updatedTask = try await taskService.markAsToDo(id: task.id)
            state.activeTasks.removeAll(where: { $0.id == task.id })
            state.activeTasks.append(updatedTask)
            state.updateTaskStatus = .loaded
        } catch {
            state.updateTaskStatus = .failed(.init(error))
        }
    }

    func onDeleteButtonTapped(_ task: DLTask) async {
        do {
            state.updateTaskStatus = .loading
            try await taskService.delete(taskId: task.id)
            state.activeTasks.removeAll(where: { $0.id == task.id })
            state.scene.removeTrashNode(for: task)
            state.updateTaskStatus = .loaded
        } catch {
            state.updateTaskStatus = .failed(.init(error))
        }
    }

    func onAddTaskConfirmed(text: String) async {
        guard
            let url = URL(string: text),
            UIApplication.shared.canOpenURL(url),
            !(url.host()?.isEmpty ?? true)
        else {
            state.addTaskStatus = .failed(.presenter(.task(.invalidURL)))
            return
        }
        do {
            state.addTaskStatus = .loading
            let task = try await taskService.add(url: url)
            if task.isToDo {
                state.activeTasks.append(task)
                state.scene.addTaskNode(for: task)
            }
            state.addTaskStatus = .loaded
        } catch {
            state.addTaskStatus = .failed(.init(error))
        }
        state.isAddTaskDialogPresented = false
    }
}

private extension TaskListPresenter {
    func refreshNodes() async {
        state.scene.removeBinNode()
        state.scene.removeTrashNodes()
        state.scene.addBinNode(radius: 172 / 2)
        state.renderedTasks = []
        state.activeTasks.forEach { task in
            state.scene.addTaskNode(for: task)
            state.renderedTasks.append(task)
        }
    }
}
