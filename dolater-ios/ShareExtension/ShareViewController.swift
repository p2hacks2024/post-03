//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

final class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let hostingController = UIHostingController(rootView: ShareView())
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        hostingController.rootView.model.configure(context: extensionContext)
    }
}
