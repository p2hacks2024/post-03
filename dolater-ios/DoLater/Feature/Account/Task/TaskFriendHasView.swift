//
//  TaskFriendHasView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/15/24.
//

import SwiftUI

struct TaskFriendHasView: View {
    private let task: DLTask
    private let markAsCompletedAction: () -> Void
    private let markAsToDoAction: () -> Void

    init(
        task: DLTask,
        markAsCompleted markAsCompletedAction: @escaping () -> Void,
        markAsToDo markAsToDoAction: @escaping () -> Void
    ) {
        self.task = task
        self.markAsCompletedAction = markAsCompletedAction
        self.markAsToDoAction = markAsToDoAction
    }

    var body: some View {
        VStack(spacing: 40) {
            TaskPreview(task: task)

            VStack(spacing: 4) {
                DLButton(.text("完了にする"), isFullWidth: true) {
                    markAsCompletedAction()
                }

                DLButton(.text("削除する"), style: .alert, isFullWidth: true) {
                    markAsToDoAction()
                }
            }
        }
        .padding(24)
    }
}

#Preview {
    TaskFriendHasView(task: .mock1) {
    } markAsToDo: {
    }
}
