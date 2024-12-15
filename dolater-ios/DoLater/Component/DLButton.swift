//
//  DLButton.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

struct DLButton: View {
    enum ButtonType {
        case icon(_ systemName: String)
        case text(_ label: String)
    }

    enum ButtonStyle {
        case primary
        case secondary
        case tertiary
        case alert

        var background: Color {
            switch self {
            case .primary:
                Color.Semantic.Background.tertiary

            case .secondary:
                Color.Semantic.Background.secondary

            case .tertiary:
                Color.clear

            case .alert:
                Color.clear
            }
        }

        var foreground: Color {
            switch self {
            case .primary:
                Color.Semantic.Text.inversePrimary

            case .secondary:
                Color.Semantic.Text.primary

            case .tertiary:
                Color.Semantic.Text.primary

            case .alert:
                Color.Semantic.Text.alert
            }
        }
    }

    private let type: ButtonType
    private let style: ButtonStyle
    private let isFullWidth: Bool
    private let action: () -> Void

    init(
        _ type: ButtonType,
        style: ButtonStyle = .primary,
        isFullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self.type = type
        self.style = style
        self.isFullWidth = isFullWidth
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Group {
                switch type {
                case .icon(let systemName):
                    Image(systemName: systemName)
                        .frame(width: 44, height: 44)

                case .text(let label):
                    Text(label)
                        .padding(.horizontal, 18)
                        .frame(height: 44)
                }
            }
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .font(.DL.button)
            .background(style.background)
            .clipShape(Capsule())
            .foregroundStyle(style.foreground)
            .shadow()
        }
    }
}

#Preview {
    VStack(alignment: .leading) {
        DLButton(.icon("plus")) {}

        DLButton(.text("追加する")) {}

        DLButton(.icon("plus"), isFullWidth: true) {}

        DLButton(.text("追加する"), isFullWidth: true) {}
    }
    .padding()
}
