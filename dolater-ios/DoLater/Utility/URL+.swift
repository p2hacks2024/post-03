//
//  URL+.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/12/24.
//

import Foundation

extension URL {
    var favicon: URL? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let faviconURLString = components
                .scheme?
                .appending("://")
                .appending(components.host ?? "")
                .appending("/favicon.ico")
        else {
            return nil
        }
        return URL(string: faviconURLString)
    }
}
