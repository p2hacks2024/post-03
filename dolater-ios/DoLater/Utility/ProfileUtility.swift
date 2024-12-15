//
//  ProfileUtility.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Foundation

enum ProfileUtility {
    static func buildFullName(givenName: String?, middleName: String? = nil, familyName: String?)
        -> String
    {
        [givenName, middleName, familyName]
            .compactMap(\.self)
            .joined(separator: " ")
    }

    static func buildFullName(fullName: PersonNameComponents) -> String {
        buildFullName(
            givenName: fullName.givenName,
            middleName: fullName.middleName,
            familyName: fullName.familyName
        )
    }
}
