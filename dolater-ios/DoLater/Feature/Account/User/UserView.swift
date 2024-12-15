//
//  UserView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/14/24.
//

import SwiftUI

struct UserView<Environment: EnvironmentProtocol>: View {
    @State private var presenter: UserPresenter<Environment>

    init(user: Components.Schemas.User) {
        self.presenter = .init(user: user)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                HStack(spacing: 18) {
                    UserIcon(imageURLString: presenter.state.user.photoURL)
                    .frame(width: 60, height: 60)

                    HStack(spacing: 4) {
                        Text(presenter.state.user.displayName.isEmpty ? "未設定" : presenter.state.user.displayName)
                            .font(.DL.title1)

                        Button("", systemImage: "link") {
                            UIPasteboard.general.url = presenter.state.user.profileURL
                        }
                        .font(.DL.button)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Group {
                    if presenter.state.isFollowing {
                        DLButton(.text("フォロー中"), style: .secondary) {
                            presenter.dispatch(.onUnfollowButtonTapped)
                        }
                    } else {
                        DLButton(.text("フォローする")) {
                            presenter.dispatch(.onFollowButtonTapped)
                        }
                    }
                }
                .disabled(presenter.state.getFollowStatus.isLoading)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 24)
            .foregroundStyle(Color.Semantic.Text.primary)
        }
        .navigationTitle(presenter.state.user.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .errorAlert(dataStatus: presenter.state.getFollowStatus)
    }
}

#Preview {
    NavigationStack {
        UserView<MockEnvironment>(user: .mock1)
    }
    .colorScheme(.light)
}
