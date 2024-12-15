//
//  UserIcon.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/14/24.
//

import SwiftUI

struct UserIcon: View, Sendable {
    private let imageURLString: String
    private let isLoading: Bool

    init(imageURLString: String, isLoading: Bool = false) {
        self.imageURLString = imageURLString
        self.isLoading = isLoading
    }

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else {
                AsyncImage(url: URL(string: imageURLString)) { phase in
                    switch phase {
                    case .empty:
                        placeholder

                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()

                    case .failure:
                        placeholder

                    @unknown default:
                        placeholder
                    }
                }
            }
        }
        .clipShape(Circle())
    }

    private var placeholder: some View {
        Image(systemName: "person.crop.circle")
            .resizable()
            .scaledToFit()
    }
}

#Preview {
    UserIcon(imageURLString: "")
        .frame(width: 100, height: 100)

    UserIcon(imageURLString: "https://cdn.bsky.app/img/avatar/plain/did:plc:dcx2gensdrmjl6vi2bf74brj/bafkreielghxxdlqctrvy6vtcgegnbnqzasfxs5bxhgcei4kxa4etsmlcrq@jpeg")
        .frame(width: 100, height: 100)
}
