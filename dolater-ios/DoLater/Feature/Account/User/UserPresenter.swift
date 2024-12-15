//
//  UserPresenter.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/14/24.
//

import Observation

@Observable
final class UserPresenter<Environment: EnvironmentProtocol>: PresenterProtocol {
    struct State: Hashable, Sendable {
        var user: Components.Schemas.User
        var isFollowing: Bool = false
        var getFollowStatus: DataStatus = .default
    }

    enum Action: Hashable, Sendable {
        case onAppear
        case onFollowButtonTapped
        case onUnfollowButtonTapped
    }

    var state: State

    private let accountService: AccountService<Environment> = .init()
    private let userService: UserService<Environment> = .init()

    init(user: Components.Schemas.User) {
        self.state = .init(user: user)
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

        case .onFollowButtonTapped:
            await onFollowButtonTapped()

        case .onUnfollowButtonTapped:
            await onUnfollowButtonTapped()
        }
    }
}

private extension UserPresenter {
    func onAppear() async {
        do {
            state.getFollowStatus = .loading
            let followings = try await accountService.getFollowings()
            state.isFollowing = followings.contains(state.user)
            state.getFollowStatus = .loaded
        } catch {
            state.getFollowStatus = .failed(.init(error))
        }
    }

    func onFollowButtonTapped() async {
        do {
            state.getFollowStatus = .loading
            _ = try await userService.follow(id: state.user.id)
            state.isFollowing = true
            state.getFollowStatus = .loaded
        } catch {
            state.getFollowStatus = .failed(.init(error))
        }
    }

    func onUnfollowButtonTapped() async {
        do {
            state.getFollowStatus = .loading
            _ = try await userService.unfollow(id: state.user.id)
            state.isFollowing = false
            state.getFollowStatus = .loaded
        } catch {
            state.getFollowStatus = .failed(.init(error))
        }
    }
}
