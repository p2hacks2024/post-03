//
//  TaskPreview.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/15/24.
//

import SwiftUI

struct TaskPreview: View {
    private let task: DLTask
    @State private var title: String = ""
    @State private var imageURL: URL? = nil
    @State private var isTitleLoading: Bool = false

    init(task: DLTask) {
        self.task = task
    }

    var body: some View {
        VStack(spacing: 54) {
            task.trashImage
                .resizable()
                .scaledToFit()
                .frame(width: 268)
                .overlay(alignment: .bottomLeading) {
                    if !task.isMyTask {
                        UserIcon(imageURLString: task.owner.photoURL)
                            .frame(width: 90, height: 90)
                    }
                }

            HStack(alignment: .top, spacing: 18) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        Circle()
                            .fill(Color.Semantic.Text.secondary)

                    case .success(let image):
                        image
                            .resizable()

                    default:
                        Image(systemName: "globe")
                            .resizable()
                    }
                }
                .scaledToFit()
                .frame(width: 32, height: 32)

                if isTitleLoading {
                    Rectangle()
                        .fill(Color.Semantic.Text.secondary)
                        .frame(maxWidth: .infinity, maxHeight: 32)
                } else {
                    Text(title)
                        .multilineTextAlignment(.leading)
                        .font(.DL.body1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .task {
            guard let url = URL(string: task.url) else {
                return
            }
            imageURL = url.favicon
            isTitleLoading = true
            defer { isTitleLoading = false }
            do {
                title = try await HTTPMetadata.getPageTitle(for: url)
            } catch {
                title = ""
            }
        }
    }
}

#Preview {
    TaskPreview(task: .mock1)
}
