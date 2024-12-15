//
//  ShareModel.swift
//  ShareExtension
//
//  Created by Kanta Oikawa on 12/12/24.
//

import SwiftUI
import UniformTypeIdentifiers

@Observable
final class ShareModel: @unchecked Sendable {
    var extensionContext: NSExtensionContext?
    var url: URL?

    //private let taskService: TaskService<EnvironmentImpl> = .init()

    func configure(context: NSExtensionContext?) {
        extensionContext = context

        guard
            let item = context?.inputItems.first as? NSExtensionItem,
            let itemProvider = item.attachments?.first,
            itemProvider.hasItemConformingToTypeIdentifier(UTType.url.identifier)
        else {
            let error = ShareError.failedToGetURL
            extensionContext?.cancelRequest(withError: error)
            return
        }

        Task {
            do {
                let data = try await itemProvider.loadItem(forTypeIdentifier: UTType.url.identifier)
                self.url = data as? URL
            } catch {
                extensionContext?.cancelRequest(withError: error)
            }
        }
    }

    func onSave() {
        Task {
            //guard let string = url?.absoluteString else {
                //extensionContext?.cancelRequest(withError: ShareError.failedToGetURL)
            //}
            //do {
                //try await taskService.addTask(.init(url: string))
                extensionContext?.completeRequest(returningItems: nil)
            //} catch {
                //extensionContext?.cancelRequest(withError: error)
            //}
        }
    }

    func onCancel() {
        extensionContext?.cancelRequest(withError: ShareError.cancel)
    }

    enum ShareError: LocalizedError {
        case cancel
        case failedToGetURL

        var errorDescription: String? {
            switch self {
            case .cancel:
                "Cancelled"
            case .failedToGetURL:
                "Failed to get URL"
            }
        }
    }
}

extension NSExtensionContext: @retroactive @unchecked Sendable {}
