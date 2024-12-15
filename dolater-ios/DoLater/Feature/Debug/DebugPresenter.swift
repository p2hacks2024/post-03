//
//  DebugPresenter.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Observation

@Observable
final class DebugPresenter<Environment: EnvironmentProtocol>: PresenterProtocol {
    struct State: Hashable, Sendable {
        var serverEnvironment: ServerEnvironment = .production
        var getServerEnvironmentStatus: DataStatus = .default
        var setServerEnvironmentStatus: DataStatus = .default

        var isSpriteKitDebugModeEnabled: Bool = false
        var getSpriteKitDebugMode: DataStatus = .default
        var setSpriteKitDebugMode: DataStatus = .default

        var appCheckToken: String = ""
        var getAppCheckTokenStatus: DataStatus = .default

        var fcmToken: String = ""
        var getFCMTokenStatus: DataStatus = .default

        var uid: String = ""
        var getUIDStatus: DataStatus = .default

        var idToken: String = ""
        var getIDTokenStatus: DataStatus = .default

        var isLoading: Bool {
            getServerEnvironmentStatus.isLoading
                || setServerEnvironmentStatus.isLoading
                || getAppCheckTokenStatus.isLoading
                || getFCMTokenStatus.isLoading
                || getIDTokenStatus.isLoading
                || getSpriteKitDebugMode.isLoading
        }
    }

    enum Action: Hashable, Sendable {
        case onAppear
        case onServerEnvironmentChanged
        case onSpriteKitDebugModeChanged
    }

    var state: State = .init()

    private let debugService: DebugService<Environment> = .init()

    func dispatch(_ action: Action) {
        Task {
            await dispatch(action)
        }
    }

    func dispatch(_ action: Action) async {
        switch action {
        case .onAppear:
            await onAppear()

        case .onServerEnvironmentChanged:
            await onServerEnvironmentChanged()

        case .onSpriteKitDebugModeChanged:
            await onSpriteKitDebugModeChanged()
        }
    }
}

extension DebugPresenter {
    fileprivate func onAppear() async {
        Task {
            state.getServerEnvironmentStatus = .loading
            state.serverEnvironment = await debugService.getServerEnvironment()
            state.getServerEnvironmentStatus = .loaded
        }

        Task {
            state.getSpriteKitDebugMode = .loading
            state.isSpriteKitDebugModeEnabled = await debugService.getSpriteKitDebugMode()
            state.getSpriteKitDebugMode = .loaded
        }

        Task {
            do {
                state.getAppCheckTokenStatus = .loading
                state.appCheckToken = try await debugService.getAppCheckToken()
                state.getAppCheckTokenStatus = .loaded
            } catch {
                state.getAppCheckTokenStatus = .failed(.init(error))
            }
        }

        Task {
            do {
                state.getFCMTokenStatus = .loading
                state.fcmToken = try await debugService.getFCMToken()
                state.getFCMTokenStatus = .loaded
            } catch {
                state.getFCMTokenStatus = .failed(.init(error))
            }
        }

        Task {
            do {
                state.getUIDStatus = .loading
                state.uid = try await debugService.getUID()
                state.getIDTokenStatus = .loaded
            } catch {
                state.getIDTokenStatus = .failed(.init(error))
            }
        }

        Task {
            do {
                state.getIDTokenStatus = .loading
                state.idToken = try await debugService.getIdToken()
                state.getIDTokenStatus = .loaded
            } catch {
                state.getIDTokenStatus = .failed(.init(error))
            }
        }
    }

    fileprivate func onServerEnvironmentChanged() async {
        do {
            state.setServerEnvironmentStatus = .loading
            try await debugService.setServerEnvironment(state.serverEnvironment)
            state.setServerEnvironmentStatus = .loaded
        } catch {
            state.setServerEnvironmentStatus = .failed(.init(error))
        }
    }

    fileprivate func onSpriteKitDebugModeChanged() async {
        do {
            state.setSpriteKitDebugMode = .loading
            try await debugService.setServerEnvironment(state.serverEnvironment)
            state.setSpriteKitDebugMode = .loaded
        } catch {
            state.setSpriteKitDebugMode = .failed(.init(error))
        }
    }
}
