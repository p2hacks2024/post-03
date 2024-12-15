//
//  NotificationListView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/15/24.
//

import SwiftUI

struct NotificationListView<Environment: EnvironmentProtocol>: View {
    @State private var presenter: NotificationListPresenter<Environment> = .init()

    var body: some View {
        Group {
            if presenter.state.getNotificationsStatus.isLoading && presenter.state.notifications.isEmpty {
                ProgressView()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(presenter.state.notifications) { notification in
                            NotificationCard(notification: notification)
                        }
                    }
                    .padding(24)
                }
                .refreshable {
                    await presenter.dispatch(.onRefresh)
                }
            }
        }
        .navigationTitle("お知らせ")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await presenter.dispatch(.onAppear)
        }
        .errorAlert(dataStatus: presenter.state.getNotificationsStatus)
    }
}

#Preview {
    NotificationListView<MockEnvironment>()
}
