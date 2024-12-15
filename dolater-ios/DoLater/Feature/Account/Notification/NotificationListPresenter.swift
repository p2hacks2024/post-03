//
//  NotificationListPresenter.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/15/24.
//

import Observation

@Observable
final class NotificationListPresenter<Environment: EnvironmentProtocol>: PresenterProtocol {
    struct State: Hashable, Sendable {
        var notifications: [Components.Schemas.Notification] = []

        var getNotificationsStatus: DataStatus = .default
    }

    enum Action: Hashable, Sendable {
        case onAppear
        case onRefresh
    }

    var state: State = .init()

    private let notificationService: NotificationService<Environment> = .init()

    func dispatch(_ action: Action) {
        Task {
            await dispatch(action)
        }
    }

    func dispatch(_ action: Action) async {
        switch action {
        case .onAppear:
            await onAppear()

        case .onRefresh:
            await onRefresh()
        }
    }
}

private extension NotificationListPresenter {
    func onAppear() async {
        await refresh()
    }

    func onRefresh() async {
        await refresh()
    }
}

private extension NotificationListPresenter {
    func refresh() async {
        do {
            state.getNotificationsStatus = .loading
            state.notifications = try await notificationService.get()
            state.notifications.sort { lhs, rhs in
                lhs.createdAt > rhs.createdAt
            }
            state.getNotificationsStatus = .loaded
        } catch {
            state.getNotificationsStatus = .failed(.init(error))
        }
    }
}
