//
//  Collection+.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
