//
//  Logger.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Foundation
import os

enum Logger {
    static let standard = os.Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: LogCategory.standard.rawValue
    )
}

enum LogCategory: String {
    case standard = "Standard"
}
