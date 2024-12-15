//
//  SignInWithAppleError.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Foundation

enum AccountServiceError: LocalizedError {
    case noPreviousRequest
    case noIdentityToken
    case failedToSerializeToken
    case failedToConvertImageToData
    case failedToGetURL

    var errorDescription: String? {
        switch self {
        case .noPreviousRequest:
            "No previous request was made."

        case .noIdentityToken:
            "No identity token was found."

        case .failedToSerializeToken:
            "Failed to serialize the identity token."

        case .failedToConvertImageToData:
            "Failed to convert image to data."

        case .failedToGetURL:
            "Failed to get URL."
        }
    }
}
