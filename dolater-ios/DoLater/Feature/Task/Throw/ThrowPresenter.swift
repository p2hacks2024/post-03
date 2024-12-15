//
//  ThrowPresenter.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/15/24.
//

import Observation

@Observable
final class ThrowPresenter<Environment: EnvironmentProtocol>: PresenterProtocol {
    struct State: Hashable, Sendable {
        var tasks: [DLTask]
        var scene: ThrowScene<Environment>
    }

    enum Action: Hashable, Sendable {
        case onArchive(DLTask)
    }

    var state: State

    private let taskService: TaskService<Environment> = .init()

    init(tasks: [DLTask]) {
        let scene = ThrowScene<Environment>()
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .clear
        state = .init(tasks: tasks, scene: scene)
    }

    func dispatch(_ action: Action) {
        Task {
            await dispatch(action)
        }
    }

    func dispatch(_ action: Action) async {
        switch action {
        case .onArchive(let task):
            await onArchive(task)
        }
    }
}

private extension ThrowPresenter {
    func onArchive(_ task: DLTask) async {
        guard let archivedTask = try? await taskService.archive(id: task.id) else {
            return
        }
        state.tasks.removeAll(where: { $0.id == archivedTask.id })
    }
}
