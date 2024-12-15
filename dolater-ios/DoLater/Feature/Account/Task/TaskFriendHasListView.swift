//
//  TaskFriendHasListView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/14/24.
//

import SwiftUI

struct TaskFriendHasListView: View {
    private let tasks: [Components.Schemas.User: [DLTask]]
    private let isLoading: Bool
    private let onTaskTappedAction: (DLTask) -> Void
    private let onMarkAsToDoAction: (DLTask) -> Void
    private let onMarkAsCompletedAction: (DLTask) -> Void
    private let onDeletedAction: (DLTask) -> Void

    init(
        tasks: [Components.Schemas.User : [DLTask]],
        isLoading: Bool = false,
        onTaskTapped onTaskTappedAction: @escaping (DLTask) -> Void,
        onMarkAsToDo onMarkAsToDoAction: @escaping (DLTask) -> Void,
        onMarkAsCompleted onMarkAsCompletedAction: @escaping (DLTask) -> Void,
        onDeleted onDeletedAction: @escaping (DLTask) -> Void
    ) {
        self.tasks = tasks
        self.isLoading = isLoading
        self.onTaskTappedAction = onTaskTappedAction
        self.onMarkAsToDoAction = onMarkAsToDoAction
        self.onMarkAsCompletedAction = onMarkAsCompletedAction
        self.onDeletedAction = onDeletedAction
    }

    var body: some View {
        LazyVStack(spacing: 18) {
            Text("友達に預けたあとまわしリンク")
                .font(.DL.title2)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            if isLoading {
                ProgressView()
            } else if tasks.isEmpty {
                Text("あとまわしリンクがありません")
                    .font(.DL.title3)
                    .foregroundStyle(Color.Semantic.Text.secondary)
            } else {
                ForEach(Array(tasks.keys.enumerated()), id: \.0) { i, user in
                    if let tasks = tasks[user] {
                        cardView(user: user, tasks: tasks)
                        if i != tasks.count - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
        .padding()
        .foregroundStyle(Color.Semantic.Text.primary)
        .background(Color.Semantic.Background.secondary)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    func cardView(user: Components.Schemas.User, tasks: [DLTask]) -> some View {
        LazyVStack(spacing: 10) {
            HStack(spacing: 4) {
                UserIcon(imageURLString: user.photoURL)
                    .frame(width: 16, height: 16)

                Text(user.displayName)
                    .font(.DL.body2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(tasks) { task in
                HStack(spacing: 10) {
                    TaskLabelView(url: task.url, isFullWidth: true, alignment: .leading)
                        .frame(maxWidth: .infinity)
                        .contextMenu {
                            if task.isCompleted {
                                Button("未完了にする", systemImage: "square") {
                                    onMarkAsToDoAction(task)
                                }
                            } else {
                                Button("完了にする", systemImage: "checkmark.square") {
                                    onMarkAsCompletedAction(task)
                                }
                            }
                            Button("削除する", systemImage: "trash", role: .destructive) {
                                onDeletedAction(task)
                            }
                        }

                    Text("\(task.passedDays)日")
                        .font(.DL.note1)
                }
                .onTapGesture {
                    onTaskTappedAction(task)
                }
            }
        }
    }
}

#Preview {
    ScrollView {
        TaskFriendHasListView(
            tasks: [
                .mock1: DLTask.mocks,
                .mock2: DLTask.mocks,
            ]
        ) { _ in
        } onMarkAsToDo: { _ in
        } onMarkAsCompleted: { _ in
        } onDeleted: { _ in
        }
    }
}
