//
//  DoLaterApp.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/7/24.
//

import SwiftUI

@main
struct DoLaterApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate<EnvironmentImpl>.self) private var delegate

    var body: some Scene {
        WindowGroup {
            ContentView<EnvironmentImpl>()
                .preferredColorScheme(.light)
        }
    }
}
