//
//  ContentPresenter.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

@preconcurrency import FirebaseAuth
import Observation
import SwiftUI

@Observable
final class ContentPresenter<Environment: EnvironmentProtocol>: PresenterProtocol {
    struct State: Equatable {
        var authStatus: AuthStatus = .unchecked

        var isDebugScreenPresented: Bool = false
        var selection: TabBarItem = .home

        var homeNavigationPath: NavigationPath = .init()
        var accountNavigationPath: NavigationPath = .init()
        var isAddTaskDialogPresented: Bool = false

        var appStoreURL: URL?

        var appVersionValidation: DataStatus = .default
        var registerMeStatus: DataStatus = .default
        var openURLStatus: DataStatus = .default

        enum AuthStatus: Hashable, Sendable {
            case unchecked
            case authenticated(User)
            case unauthenticated
        }
    }

    enum Action: Sendable {
        case onAppear
        case onOpenURL(URL)
        case onSelectedTabChanged
        case onPlusButtonTapped
    }

    var state: State = .init()

    private let accountService: AccountService<Environment> = .init()
    private let taskService: TaskService<Environment> = .init()
    private let userService: UserService<Environment> = .init()

    private var authListener: NSObjectProtocol?

    init() {
        authListener = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if let user = user {
                self?.state.authStatus = .authenticated(user)
                Task {
                    await self?.registerMe()
                }
            } else {
                self?.state.authStatus = .unauthenticated
            }
        }
    }

    deinit {
        Task { [weak self] in
            if let listener = await self?.authListener {
                Auth.auth().removeStateDidChangeListener(listener)
            }
        }
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

        case .onOpenURL(let url):
            await onOpenURL(url)

        case .onSelectedTabChanged:
            await onSelectedTabChanged()

        case .onPlusButtonTapped:
            await onPlusButtonTapped()
        }
    }
}

extension ContentPresenter {
    fileprivate func onAppear() async {
        state.appStoreURL = URL(string: (try? await Environment.shared.remoteConfigRepository.fetchString(for: .appStoreURL)) ?? "")
        do {
            let isValidAppVersion = try await Environment.shared.remoteConfigRepository.fetchBool(for: .isValidAppVersion)
            if !isValidAppVersion {
                throw PresenterError.invalidAppVersion
            }
        } catch {
            state.appVersionValidation = .failed(.init(error))
        }
    }

    fileprivate func onOpenURL(_ url: URL) async {
        Logger.standard.debug("Open URL: \(url.absoluteString)")
        let pathComponents = url.pathComponents
        switch pathComponents[safe: 1] {
        case "users":
            guard let id = pathComponents[safe: 2] else {
                return
            }
            do {
                state.openURLStatus = .loading
                state.selection = .account
                let me = try await accountService.getMe()
                if id == me.id {
                    state.openURLStatus = .loaded
                    return
                }
                let user = try await userService.get(id: id)
                state.accountNavigationPath = .init([AccountPresenter<Environment>.State.Path.user(user)])
                state.openURLStatus = .loaded
            } catch {
                state.openURLStatus = .failed(.init(error))
            }

        case "tasks":
            guard let id = pathComponents[safe: 2] else {
                return
            }
            do {
                state.openURLStatus = .loading
                let task = try await taskService.get(id: id)
                let me = try await accountService.getMe()
                if task.pool.owner?.id == me.id {
                    state.selection = .home
                    state.homeNavigationPath = .init([TaskListPresenter<Environment>.State.Path.detail(task)])
                } else {
                    state.selection = .account
                    state.accountNavigationPath = .init([AccountPresenter<Environment>.State.Path.task(task)])
                }
                state.openURLStatus = .loaded
            } catch {
                state.openURLStatus = .failed(.init(error))
            }

        default:
            return
        }
    }

    fileprivate func onSelectedTabChanged() async {
        state.isAddTaskDialogPresented = false
    }

    fileprivate func onPlusButtonTapped() async {
        state.selection = .home
        state.isAddTaskDialogPresented = true
    }
}

private extension ContentPresenter {
    func registerMe() async {
        do {
            state.registerMeStatus = .default
            try await accountService.registerMe()
            state.registerMeStatus = .loaded
        } catch {
            state.registerMeStatus = .failed(.init(error))
        }
    }
}
