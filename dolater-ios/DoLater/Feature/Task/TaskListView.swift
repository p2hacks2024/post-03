//
//  TaskListView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SpriteKit
import SwiftUI

struct TaskListView<Environment: EnvironmentProtocol>: View {
    @State private var presenter: TaskListPresenter<Environment>
    @Binding private var path: NavigationPath
    @Binding private var isAddTaskDialogPresented: Bool

    init(
        path: Binding<NavigationPath>,
        isAddTaskDialogPresented: Binding<Bool>
    ) {
        _path = path
        _isAddTaskDialogPresented = isAddTaskDialogPresented
        presenter = .init(path: path.wrappedValue)
    }

    var body: some View {
        NavigationStack(path: $presenter.state.path) {
            SpriteView(
                scene: presenter.state.scene,
                options: [.allowsTransparency],
                debugOptions: presenter.state.isSpriteKitDebugMode ? [
                    .showsDrawCount,
                    .showsFields,
                    .showsFPS,
                    .showsNodeCount,
                    .showsPhysics,
                    .showsQuadCount,
                ] : []
            )
            .background(Color.Semantic.Background.primary)
            .overlay {
                binView
            }
            .overlay {
                if presenter.state.getActiveTasksStatus == .loading {
                    ProgressView()
                } else if presenter.state.activeTasks.isEmpty {
                    noTaskMessageView
                } else {
                    tasksView
                }
            }
            .navigationDestination(for: TaskListPresenter<Environment>.State.Path.self) { destination in
                switch destination {
                case .detail(let task):
                    TaskDetailView(task: task) {
                        presenter.dispatch(.onMarkAsCompletedButtonTapped(task))
                        presenter.state.path.removeLast()
                    } onMarkAsToDo: {
                        presenter.dispatch(.onMarkAsToDoButtonTapped(task))
                        presenter.state.path.removeLast()
                    }

                case .preview(let task):
                    TaskNotifyView(task: task) {
                    }
                }
            }
            .errorAlert(dataStatus: presenter.state.getActiveTasksStatus)
            .errorAlert(dataStatus: presenter.state.getRemovedTasksStatus)
            .errorAlert(dataStatus: presenter.state.updateTaskStatus)
            .errorAlert(dataStatus: presenter.state.addTaskStatus)
        }
        .overlay {
            if presenter.state.isAddTaskDialogPresented {
                AddTaskView(
                    status: presenter.state.addTaskStatus
                ) {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        presenter.state.isAddTaskDialogPresented = false
                    }
                } onConfirm: { text in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        presenter.dispatch(.onAddTaskConfirmed(text))
                    }
                }
            }
        }
        .overlay {
            if presenter.state.isBinPresented {
                ThrowView<Environment>(tasks: presenter.state.removedTasks) {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        presenter.state.isBinPresented = false
                    }
                }
            }
        }
        .task {
            await presenter.dispatch(.onAppear)
        }
        .sync($path, $presenter.state.path)
        .sync($isAddTaskDialogPresented, $presenter.state.isAddTaskDialogPresented)
    }

    private var binView: some View {
        BinView(isFull: !presenter.state.removedTasks.isEmpty)
            .frame(width: 172)
            .dropDestination(for: DLTask.self) { droppedTasks, droppedPoint in
                presenter.dispatch(.onTasksDropped(droppedTasks, droppedPoint))
                return true
            }
            .onTapGesture {
                presenter.dispatch(.onBinTapped)
            }
            .position(presenter.state.scene.convertPoint(toView: presenter.state.scene.binPosition))
    }

    private var noTaskMessageView: some View {
        Text("あとまわしリンクがありません")
            .font(.DL.title1)
            .foregroundStyle(Color.Semantic.Text.secondary)
    }

    private var tasksView: some View {
        ForEach(presenter.state.renderingTasks) { task in
            if let position = presenter.state.scene.trashPositions[task.displayName],
               let rotation = presenter.state.scene.trashRotations[task.displayName] {
                taskView(
                    task,
                    position: presenter.state.scene.convertPoint(toView: position),
                    rotation: -rotation
                )
            }
        }
    }

    private func taskView(_ task: DLTask, position: CGPoint, rotation: CGFloat) -> some View {
        TaskItemView(task: task, rotationAngle: .radians(rotation)) {
            presenter.dispatch(.onMarkAsCompletedButtonTapped(task))
        } onMarkAsToDo: {
            presenter.dispatch(.onMarkAsToDoButtonTapped(task))
        } onDelete: {
            presenter.dispatch(.onDeleteButtonTapped(task))
        }
        .draggable(task)
        .onTapGesture {
            presenter.dispatch(.onTaskTapped(task))
        }
        .position(position)
    }
}

#Preview {
    @Previewable @State var path: NavigationPath = .init()
    @Previewable @State var isAddTaskDialogPresented: Bool = false

    NavigationStack {
        TaskListView<MockEnvironment>(
            path: $path,
            isAddTaskDialogPresented: $isAddTaskDialogPresented
        )
    }
}
