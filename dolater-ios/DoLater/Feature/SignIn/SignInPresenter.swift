//
//  SignInPresenter.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/10/24.
//

import AuthenticationServices
import Observation

@Observable
final class SignInPresenter<Environment: EnvironmentProtocol>: PresenterProtocol {
    struct State: Equatable, Sendable {
        var signInStatus: DataStatus = .default
        var email: String = ""
        var password: String = ""
    }

    enum Action: Sendable {
        case onSignInWithAppleRequested(ASAuthorizationAppleIDRequest)
        case onSignInWithAppleCompleted(Result<ASAuthorization, Error>)
        case onSignInButtonTapped
    }

    var state: State = .init()

    private let accountService: AccountService<Environment> = .init()

    private(set) var currentNonce: String?

    func dispatch(_ action: Action) {
        Task {
            await dispatch(action)
        }
    }

    func dispatch(_ action: Action) async {
        switch action {
        case .onSignInWithAppleRequested(let request):
            await onSignInWithAppleRequested(request: request)

        case .onSignInWithAppleCompleted(let result):
            await onSignInWithAppleCompleted(result: result)

        case .onSignInButtonTapped:
            await onSignInButtonTapped()
        }
    }
}

private extension SignInPresenter {
    func onSignInWithAppleRequested(request: ASAuthorizationAppleIDRequest) async {
        currentNonce = await accountService.onSignInWithAppleRequested(request: request)
    }

    func onSignInWithAppleCompleted(result: Result<ASAuthorization, Error>) async {
        state.signInStatus = .loading
        do {
            try await accountService.onSignInWithAppleCompleted(result: result, currentNonce: currentNonce)
            state.signInStatus = .loaded
        } catch {
            state.signInStatus = .failed(.init(error))
        }
    }

    func onSignInButtonTapped() async {
        state.signInStatus = .loading
        do {
            _ = try await accountService.signInWithEmailAndPassword(email: state.email, password: state.password)
            state.signInStatus = .loaded
        } catch {
            state.signInStatus = .failed(.init(error))
        }
    }
}
