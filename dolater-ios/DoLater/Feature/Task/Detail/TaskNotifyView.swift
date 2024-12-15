//
//  TaskNotifyView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/15/24.
//

import SwiftUI

struct TaskNotifyView: View {
    private let task: DLTask
    private let notifyAction: () -> Void

    init(task: DLTask, notifyAction: @escaping () -> Void) {
        self.task = task
        self.notifyAction = notifyAction
    }

    var body: some View {
        VStack(spacing: 40) {
            TaskPreview(task: task)

            DLButton(.text("催促する"), isFullWidth: true) {
                notifyAction()
            }
        }
        .padding(24)
    }
}

#Preview {
    TaskNotifyView(task: .mock1) {
    }
}
