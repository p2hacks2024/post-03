//
//  SignInService.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import AuthenticationServices
import FirebaseAuth
import SwiftUI

final actor AccountService<Environment: EnvironmentProtocol> {
    init() {}

    func registerMe() async throws {
        _ = try await Environment.shared.userRepository.createUser()
    }

    func getMe() async throws -> Components.Schemas.User {
        let user = try await Environment.shared.authRepository.getCurrentUser()
        return try await Environment.shared.userRepository.getUser(id: user.uid)
    }

    func getFriends() async throws -> [Components.Schemas.User] {
        let user = try await Environment.shared.authRepository.getCurrentUser()
        return try await Environment.shared.userRepository.getFriends(id: user.uid)
    }

    func getFollowings() async throws -> [Components.Schemas.User] {
        let user = try await Environment.shared.authRepository.getCurrentUser()
        return try await Environment.shared.userRepository.getFollowings(id: user.uid)
    }

    /// Make Sign in with Apple Request
    /// - Parameter request: Sign in with Apple Request
    /// - Returns: Nonce
    func onSignInWithAppleRequested(request: ASAuthorizationAppleIDRequest) -> String {
        request.requestedScopes = [.fullName, .email]
        let nonce = CryptoUtils.randomNonceString()
        request.nonce = CryptoUtils.sha256(nonce)
        return nonce
    }

    func onSignInWithAppleCompleted(
        result: Result<ASAuthorization, Error>,
        currentNonce: String?
    ) async throws {
        switch result {
        case .success(let success):
            if let appleIDCredential = success.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    let error = ServiceError.account(.noPreviousRequest)
                    Logger.standard.error("\(error)")
                    throw error
                }
                Logger.standard.debug("Authorized scopes: \(appleIDCredential.authorizedScopes)")
                guard let appleIDToken = appleIDCredential.identityToken else {
                    let error = ServiceError.account(.noIdentityToken)
                    Logger.standard.error("\(error)")
                    throw error
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    let error = ServiceError.account(.failedToSerializeToken)
                    Logger.standard.error("\(error)")
                    throw error
                }
                let credential = OAuthProvider.credential(
                    providerID: .apple, idToken: idTokenString, rawNonce: nonce)
                let result = try await Auth.auth().signIn(with: credential)
                try await updateProfile(for: result.user, with: appleIDCredential)
            }

        case .failure(let error):
            throw error
        }
    }

    func signInWithEmailAndPassword(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user
    }

    func updateProfile(displayName: String) async throws -> Components.Schemas.User {
        let firebaseUser = try await Environment.shared.authRepository.getCurrentUser()
        try await Environment.shared.authRepository.update(
            displayName: displayName,
            for: firebaseUser
        )
        return try await Environment.shared.userRepository.updateUser(
            .init(displayName: displayName),
            id: firebaseUser.uid
        )
    }

    @MainActor
    func updateProfile(image: Image) async throws -> Components.Schemas.User {
        let resizedImage = image
            .resizable()
            .scaledToFill()
            .frame(width: 512, height: 512)
        let renderer = ImageRenderer(content: resizedImage)
        guard
            let uiImage = renderer.uiImage,
            let data = uiImage.pngData()
        else {
            throw AccountServiceError.failedToConvertImageToData
        }
        let firebaseUser = try await Environment.shared.authRepository.getCurrentUser()
        let path = "profile_images/\(firebaseUser.uid)/\(UUID().uuidString.lowercased()).png"
        let metadata = try await Environment.shared.storageRepository.upload(data, to: path)
        let urlString = "https://firebasestorage.googleapis.com/v0/b/dolater-app.firebasestorage.app/o/\(metadata.path?.replacing("/", with: "%2F") ?? "")?alt=media"
        Logger.standard.debug("\(urlString)")
        guard let url = URL(string: urlString) else {
            throw AccountServiceError.failedToGetURL
        }
        try await Environment.shared.authRepository.update(
            photoURL: url,
            for: firebaseUser
        )
        return try await Environment.shared.userRepository.updateUser(
            .init(photoURL: url.absoluteString),
            id: firebaseUser.uid
        )
    }

    func signOut() async throws {
        try await Environment.shared.authRepository.signOut()
    }
}

extension AccountService {
    private func updateProfile(
        for user: User,
        with appleIDCredential: ASAuthorizationAppleIDCredential,
        force: Bool = false
    ) async throws {
        if force || (!force && !(user.displayName ?? "").isEmpty) {
            guard let fullName = appleIDCredential.fullName else {
                return
            }
            let displayName = ProfileUtility.buildFullName(fullName: fullName)
            do {
                try await Environment.shared.authRepository.update(
                    displayName: displayName,
                    for: user
                )
            } catch {
                Logger.standard.error("\(error)")
            }
        }

        if force || (!force && !(user.email ?? "").isEmpty) {
            guard let email = appleIDCredential.email else {
                return
            }
            do {
                try await Environment.shared.authRepository.update(
                    email: email,
                    for: user
                )
            } catch {
                Logger.standard.error("\(error)")
            }
        }
    }
}
