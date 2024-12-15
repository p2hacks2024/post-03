//
//  TabBarIconView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

struct TabBarIconView: View {
    enum IconType {
        case home
        case account

        var systemName: String {
            switch self {
            case .home: "house"
            case .account: "person"
            }
        }
    }

    private let type: IconType
    private let isFocused: Bool
    private let action: () -> Void

    init(
        _ type: IconType,
        isFocused: Bool,
        action: @escaping () -> Void
    ) {
        self.type = type
        self.isFocused = isFocused
        self.action = action
    }

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: type.systemName)
                .foregroundStyle(
                    isFocused ? Color.Semantic.Text.primary : Color.Semantic.Text.secondary
                )
                .font(.DL.navigationBarIcon)

            Circle()
                .fill(
                    isFocused ? Color.Semantic.Text.primary : Color.clear
                )
                .frame(width: 4, height: 4)
        }
        .frame(width: 40, height: 40)
        .onTapGesture(perform: action)
    }
}

#Preview {
    TabBarIconView(.home, isFocused: true) {}
}
