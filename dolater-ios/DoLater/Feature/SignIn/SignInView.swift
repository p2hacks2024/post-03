//
//  SignInView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/10/24.
//

import AuthenticationServices
import SwiftUI

struct SignInView<Environment: EnvironmentProtocol>: View {
    @State private var presenter: SignInPresenter<Environment> = .init()

    var body: some View {
        VStack(spacing: 24) {
            SignInWithAppleButton { request in
                presenter.dispatch(.onSignInWithAppleRequested(request))
            } onCompletion: { result in
                presenter.dispatch(.onSignInWithAppleCompleted(result))
            }
            .frame(height: 48)

#if DEBUG
            HStack {
                VStack {
                    Divider()
                }
                Text("OR")
                    .foregroundStyle(Color.Semantic.Text.secondary)
                    .font(.caption)
                VStack {
                    Divider()
                }
            }

            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    TextField("Email", text: $presenter.state.email)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    SecureField("Password", text: $presenter.state.password)
                }
                .textFieldStyle(.roundedBorder)
                Button("Sign In") {
                    presenter.dispatch(.onSignInButtonTapped)
                }
                .buttonStyle(.borderedProminent)
            }
#endif
        }
        .disabled(presenter.state.signInStatus == .loading)
        .padding()
        .errorAlert(dataStatus: presenter.state.signInStatus)
    }
}

#Preview {
    SignInView<MockEnvironment>()
}
