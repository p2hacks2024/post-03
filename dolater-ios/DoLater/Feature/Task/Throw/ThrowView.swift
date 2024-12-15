//
//  ThrowView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/15/24.
//

import SpriteKit
import SwiftUI

struct ThrowView<Environment: EnvironmentProtocol>: View {
    @State private var presenter: ThrowPresenter<Environment>
    private let onDismissAction: () -> Void

    init(tasks: [DLTask], onDismiss onDismissAction: @escaping () -> Void) {
        self.presenter = .init(tasks: tasks)
        self.onDismissAction = onDismissAction
    }

    var body: some View {
        SpriteView(
            scene: presenter.state.scene,
            options: [.allowsTransparency]
        )
        .background(Color.Semantic.Background.primary)
        .overlay {
        }
        .overlay {
            BinView(isFull: !presenter.state.tasks.isEmpty)
                .frame(width: 320)
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
    ThrowView<MockEnvironment>(tasks: DLTask.mocks) {
    }
}
