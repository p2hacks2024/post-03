//
//  TaskDetailView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/12/24.
//

import SwiftUI

struct TaskDetailView: View {
    private let task: DLTask
    private let onMarkAsCompletedAction: () -> Void
    private let onMarkAsToDoAction: () -> Void
    @State private var title: String

    init(
        task: DLTask,
        onMarkAsCompleted onMarkAsCompletedAction: @escaping () -> Void,
        onMarkAsToDo onMarkAsToDoAction: @escaping () -> Void
    ) {
        self.task = task
        self.onMarkAsCompletedAction = onMarkAsCompletedAction
        self.onMarkAsToDoAction = onMarkAsToDoAction
        title = URL(string: task.url)?.host() ?? ""
    }

    var body: some View {
        if let url = URL(string: task.url) {
            WebView(url: url)
                .task {
                    do {
                        title = try await HTTPMetadata.getPageTitle(for: url)
                    } catch {
                        title = url.host() ?? ""
                    }
                }
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        if task.isCompleted || task.isArchived {
                            Button("未完了にする") {
                                onMarkAsToDoAction()
                            }
                        } else {
                            Button("完了にする") {
                                onMarkAsCompletedAction()
                            }
                        }
                    }
                }
        }
    }
}

#Preview {
    NavigationStack {
        TaskDetailView(task: .mock1) {
        } onMarkAsToDo: {
        }
    }
}
