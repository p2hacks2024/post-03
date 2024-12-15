//
//  DLDialog.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/12/24.
//

import SwiftUI

struct DLDialog<Content>: View where Content : View {
    private let title: String
    private let content: Content
    private let button: DLButton

    init(
        title: String,
        button: DLButton,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.content = content()
        self.button = button
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.DL.title2)
                .foregroundStyle(Color.Semantic.Text.primary)
            content
            button
        }
        .padding(.vertical, 40)
        .padding(.horizontal, 30)
        .background(Color.Semantic.Background.secondary)
        .clipShape(RoundedRectangle(cornerRadius: 40))
        .shadow()
    }
}

#Preview {
    @Previewable @State var text: String = ""
    @Previewable @State var isFocused: Bool = false

    DLDialog(
        title: "あとまわしリンクを追加",
        button: DLButton(.text("追加する"), isFullWidth: true) {}
    ) {
        DLTextField("https://", text: $text, isFocused: $isFocused)
    }
    .padding()
}
