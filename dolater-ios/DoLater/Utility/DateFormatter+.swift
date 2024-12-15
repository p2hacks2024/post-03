//
//  DateFormatter+.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Foundation

extension DateFormatter {
    static let middle: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}
