//
//  AddTaskView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/13/24.
//

import SwiftUI

struct AddTaskView: View {
    private let status: DataStatus
    private let onDismissAction: () -> Void
    private let onConfirmAction: (String) -> Void
    @State private var text: String = ""

    init(
        status: DataStatus,
        onDismiss onDismissAction: @escaping () -> Void,
        onConfirm onConfirmAction: @escaping (String) -> Void
    ) {
        self.status = status
        self.onDismissAction = onDismissAction
        self.onConfirmAction = onConfirmAction
    }

    var body: some View {
        Color.clear
            .contentShape(Rectangle())
            .onTapGesture {
                onDismissAction()
            }
            .overlay {
                DLDialog(
                    title: "あとまわしリンクを追加",
                    button: DLButton(.text("追加する"), isFullWidth: true) {
                        onConfirmAction(text)
                    }
                ) {
                    VStack(alignment: .leading, spacing: 4) {
                        DLTextField(
                            "https://",
                            text: $text,
                            isFocused: .constant(true)
                        )
                        .keyboardType(.URL)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        if case let .failed(error) = status {
                            Text(error.localizedDescription)
                                .font(.DL.note1)
                                .foregroundStyle(Color.Semantic.Text.alert)
                        }
                    }
                }
                .disabled(status.isLoading)
                .padding(24)
            }
            .overlay(alignment: .topTrailing) {
                DLButton(.icon("xmark"), style: .secondary) {
                    onDismissAction()
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
            }
    }
}

#Preview {
    AddTaskView(status: .default) {
    } onConfirm: { _ in
    }
}
