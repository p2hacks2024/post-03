//
//  ErrorAlertModifier.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import SwiftUI

struct ErrorAlertModifier<V>: ViewModifier where V: View {
    @State private var isPresented = false

    private let status: DataStatus
    @ViewBuilder private let actions: (String) -> V

    private var title: String {
        status.domainError?.localizedDescription ?? ""
    }
    private var message: String? {
        status.domainError?.detail
    }

    init(
        status: DataStatus,
        @ViewBuilder actions: @escaping (String) -> V
    ) {
        self.status = status
        self.actions = actions
    }

    func body(content: Content) -> some View {
        content
            .alert(
                title,
                isPresented: $isPresented,
                presenting: message,
                actions: actions,
                message: Text.init
            )
            .onChange(of: status) { _, _ in
                isPresented = status.isFailed
            }
    }
}

extension View {
    func errorAlert(dataStatus: DataStatus) -> some View {
        modifier(
            ErrorAlertModifier(
                status: dataStatus,
                actions: { _ in }
            )
        )
    }

    func errorAlert(
        dataStatus: DataStatus,
        @ViewBuilder actions: @escaping (String) -> some View
    ) -> some View {
        modifier(
            ErrorAlertModifier(
                status: dataStatus,
                actions: actions
            )
        )
    }
}

#Preview {
    @Previewable @State var dataStatus: DataStatus = .default

    Text("")
        .errorAlert(dataStatus: dataStatus)
        .onAppear {
            dataStatus = .failed(.repository(.server(.notFound, nil)))
        }
}
