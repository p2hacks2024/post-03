//
//  AuthMiddleware.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import FirebaseAppCheck
import FirebaseAuth
import Foundation
import HTTPTypes
import OpenAPIRuntime

final actor AuthMiddleware: ClientMiddleware {
    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: @Sendable (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        let appCheckToken = try await AppCheckRepositoryImpl().getAppCheckToken()
        let user = try await AuthRepositoryImpl().getCurrentUser()
        let idToken = try await user.getIDToken(forcingRefresh: true)
        var request = request
        request.headerFields.append(
            .init(
                name: .init("X-Firebase-AppCheck")!, value: appCheckToken
            ))
        request.headerFields[.authorization] = "Bearer \(idToken)"
        return try await next(request, body, baseURL)
    }
}
