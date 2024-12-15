//
//  AccountView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import PhotosUI
import SwiftUI

struct AccountView<Environment: EnvironmentProtocol>: View {
    @State private var presenter: AccountPresenter<Environment>
    @Binding private var path: NavigationPath

    init(path: Binding<NavigationPath>) {
        presenter = .init(path: path.wrappedValue)
        _path = path
    }

    var body: some View {
        NavigationStack(path: $presenter.state.path) {
            Group {
                if presenter.state.getUserStatus.isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 24) {
                            DLButton(.icon("bell"), style: .secondary) {
                                presenter.dispatch(.onNotificationButtonTapped)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)

                            VStack(spacing: 30) {
                                VStack(spacing: 18) {
                                    if let user = presenter.state.user {
                                        profileView(user: user)
                                    }

                                    HStack(spacing: 18) {
                                        countView(
                                            label: String(localized: "フレンド"),
                                            count: presenter.state.friendsCountString
                                        )
                                        .onTapGesture {
                                            presenter.dispatch(.onFriendsCountTapped)
                                        }
                                        countView(
                                            label: String(localized: "完了したタスク"),
                                            count: presenter.state.tasksCountString
                                        )
                                        .onTapGesture {
                                            presenter.dispatch(.onArchivedTasksCountTapped)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }

                            TaskFriendHasListView(
                                tasks: presenter.state.tasksFriendHas,
                                isLoading: presenter.state.getTasksFriendHasStatus.isLoading
                            ) { task in
                                presenter.dispatch(.onTaskFriendHasTapped(task))
                            } onMarkAsToDo: { _ in
                            } onMarkAsCompleted: { _ in
                            } onDeleted: { _ in
                            }

                            Button("サインアウト") {
                                presenter.dispatch(.onSignOutButtonTapped)
                            }
                            .font(.DL.body2)
                            Button("アカウントを削除") {
                            }
                            .font(.DL.body2)
                            .foregroundStyle(Color.Semantic.Text.alert)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 24)
                        .foregroundStyle(Color.Semantic.Text.primary)
                    }
                    .refreshable {
                        await presenter.dispatch(.onRefresh)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.Semantic.Background.primary)
            .navigationDestination(for: AccountPresenter<Environment>.State.Path.self) { destination in
                switch destination {
                case .notifications:
                    NotificationListView<Environment>()

                case .friends:
                    EmptyView()

                case .archivedTasks:
                    EmptyView()

                case .task(let task):
                    TaskFriendHasView(task: task) {
                    } markAsToDo: {
                    }

                case .user(let user):
                    UserView<Environment>(user: user)
                }
            }
            .errorAlert(dataStatus: presenter.state.getUserStatus)
            .errorAlert(dataStatus: presenter.state.getFriendsCountStatus)
            .errorAlert(dataStatus: presenter.state.getTaskCountStatus)
            .errorAlert(dataStatus: presenter.state.updateProfilePhotoStatus)
            .errorAlert(dataStatus: presenter.state.updateNameStatus)
            .errorAlert(dataStatus: presenter.state.getTasksFriendHasStatus)
            .errorAlert(dataStatus: presenter.state.signOutStatus)
        }
        .sync($path, $presenter.state.path)
        .task {
            await presenter.dispatch(.onAppear)
        }
    }

    @ViewBuilder
    private func profileView(user: Components.Schemas.User) -> some View {
        let userIcon = UserIcon(
            imageURLString: user.photoURL,
            isLoading: presenter.state.updateProfilePhotoStatus.isLoading
        )
        HStack(spacing: 18) {
            PhotosPicker(
                selection: $presenter.state.photosPickerItem,
                matching: .images
            ) {
                userIcon
            }
            .frame(width: 60, height: 60)
            .onChange(of: presenter.state.photosPickerItem) { _, _ in
                presenter.dispatch(.onSelectedPhotoChanged)
            }

            if presenter.state.isNameEditing {
                HStack {
                    TextField("名前", text: $presenter.state.editingNameText)
                        .onSubmit {
                            presenter.dispatch(.onNameSubmitted)
                        }
                        .disabled(presenter.state.updateNameStatus.isLoading)
                    if presenter.state.updateNameStatus.isLoading {
                        ProgressView()
                    }
                }
            } else {
                HStack(spacing: 4) {
                    Text(user.displayName.isEmpty ? "未設定" : user.displayName)
                        .font(.DL.title1)
                        .onTapGesture {
                            presenter.dispatch(.onNameTapped)
                        }

                    Button("", systemImage: "link") {
                        UIPasteboard.general.url = user.profileURL
                    }
                    .font(.DL.button)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func countView<S>(label: S, count: S?) -> some View where S : StringProtocol {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.DL.note1)
            Text(count ?? "-")
                .font(.DL.title1)
        }
    }
}

#Preview {
    @Previewable @State var path: NavigationPath = .init()

    AccountView<MockEnvironment>(path: $path)
}
