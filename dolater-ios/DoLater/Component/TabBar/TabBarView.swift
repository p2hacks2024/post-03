//
//  TabBarView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

struct TabBarView: View {
    @Binding private var selection: TabBarItem
    private let onPlusButtonTappedAction: () -> Void

    init(
        selection: Binding<TabBarItem>,
        onPlusButtonTappedAction: @escaping () -> Void
    ) {
        self._selection = selection
        self.onPlusButtonTappedAction = onPlusButtonTappedAction
    }

    var body: some View {
        HStack {
            TabBarIconView(
                .home,
                isFocused: selection == .home
            ) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    selection = .home
                }
            }

            Spacer()

            DLButton(
                .icon("plus"),
                action: onPlusButtonTappedAction
            )

            Spacer()

            TabBarIconView(
                .account,
                isFocused: selection == .account
            ) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    selection = .account
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 80)
        .background(Color.Semantic.Background.secondary)
    }
}

#Preview {
    @Previewable @State var selection: TabBarItem = .home

    VStack(spacing: 0) {
        Spacer()
        TabBarView(selection: $selection) {}
    }
    .background(Color.Semantic.Background.primary)
}
