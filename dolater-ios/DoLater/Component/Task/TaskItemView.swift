//
//  TaskItemView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

struct TaskItemView: View {
    private let task: DLTask
    private let rotationAngle: Angle
    private let onMarkAsCompletedAction: () -> Void
    private let onMarkAsToDoAction: () -> Void
    private let onDeleteAction: () -> Void
    @State private var status: Status

    init(
        task: DLTask,
        rotationAngle: Angle,
        onMarkAsCompleted onMarkAsCompletedAction: @escaping () -> Void,
        onMarkAsToDo onMarkAsToDoAction: @escaping () -> Void,
        onDelete onDeleteAction: @escaping () -> Void
    ) {
        self.task = task
        self.rotationAngle = rotationAngle
        self.onMarkAsCompletedAction = onMarkAsCompletedAction
        self.onMarkAsToDoAction = onMarkAsToDoAction
        self.onDeleteAction = onDeleteAction
        self.status = task.isCompleted ? .closed : .opened
    }

    var body: some View {
        status.image
            .resizable()
            .scaledToFit()
            .frame(width: task.size, height: task.size)
            .overlay {
                TaskLabelView(url: task.url)
                    .frame(width: task.size * 1.2)
            }
            .overlay(alignment: .bottomLeading) {
                if !task.isMyTask {
                    UserIcon(imageURLString: task.owner.photoURL)
                        .frame(width: task.size * 0.3, height: task.size * 0.3)
                }
            }
            .rotationEffect(rotationAngle)
            .contextMenu {
                if task.isCompleted {
                    Button("未完了にする", systemImage: "square") {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            status = .opened
                        }
                        onMarkAsToDoAction()
                    }
                } else {
                    Button("完了にする", systemImage: "checkmark.square") {
                        Task {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                status = .closing
                            }
                            try await Task.sleep(nanoseconds: 800_000_000)
                            withAnimation(.easeInOut(duration: 0.2)) {
                                status = .closed
                            }
                            onMarkAsCompletedAction()
                        }
                    }
                }
                Button("削除する", systemImage: "trash", role: .destructive) {
                    onDeleteAction()
                }
            }
    }
}

extension TaskItemView {
    enum Status: String {
        case opened
        case closing
        case closed

        var image: Image {
            switch self {
            case .opened: Image.trashOpened
            case .closing: Image.trashClosing
            case .closed: Image.trashClosed
            }
        }
    }
}

#Preview {
    TaskItemView(task: .mock1, rotationAngle: .zero) {
    } onMarkAsToDo: {
    } onDelete: {
    }
}
