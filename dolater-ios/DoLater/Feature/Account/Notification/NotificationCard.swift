//
//  NotificationCard.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/15/24.
//

import SwiftUI

struct NotificationCard: View {
    @Environment(\.openURL) private var openURL
    private let notification: Components.Schemas.Notification

    init(notification: Components.Schemas.Notification) {
        self.notification = notification
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(DateFormatter.middle.string(from: notification.createdAt))
                .font(.DL.note1)
            Text(notification.title)
                .font(.DL.title3)
            Text(notification.body ?? "")
                .font(.DL.body2)
            if let url = URL(string: notification.url ?? "") {
                DLButton(.text("詳細を見る")) {
                    openURL(url)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(Color.Semantic.Text.primary)
        .background(Color.Semantic.Background.secondary)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow()
    }
}

#Preview {
    NotificationCard(notification: .mock1)
}
