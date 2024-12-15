//
//  View+Shadow.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

extension View {
    func shadow() -> some View {
        shadow(
            color: .Semantic.Shadow.primary.opacity(0.2),
            radius: 16,
            x: 2,
            y: 2
        )
    }
}
