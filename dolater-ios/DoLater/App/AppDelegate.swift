//
//  AppDelegate.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import FirebaseAppCheck
import FirebaseAuth
import FirebaseCore
import FirebaseMessaging
import SwiftUI

final class AppDelegate<Environment: EnvironmentProtocol>: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    private let notificationService: NotificationService<Environment> = .init()

    private let gcmMessageIDKey = "gcm.message_id"
    private let fcmURLKey = "url"

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // AppCheck
        let providerFactory: AppCheckProviderFactory
#if DEBUG
        providerFactory = AppCheckDebugProviderFactory()
#else
        providerFactory = MyAppCheckProviderFactory()
#endif
        AppCheck.setAppCheckProviderFactory(providerFactory)

        // Firebase
        FirebaseApp.configure()

#if targetEnvironment(simulator)
        //Auth.auth().useEmulator(withHost: "localhost", port: 9099)
#endif

        // Push Notification
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        Task {
            _ = try await UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .badge, .sound]
            )
            application.registerForRemoteNotifications()
        }

        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        Logger.standard.debug("AppDelegate OpenURL: \(url.absoluteString)")

        let sendingAppID = options[.sourceApplication]
        Logger.standard.debug("Source Application: \(sendingAppID.debugDescription)")

        if url.host() == "dolater.kantacky.com" {
            return true
        }

        guard let _ = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return false
        }

        return false
    }

    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any]
    ) async -> UIBackgroundFetchResult {
        if let messageID = userInfo[gcmMessageIDKey] {
            Logger.standard.debug("Message ID: \(messageID as? String ?? "")")
        }
        Logger.standard.debug("\(userInfo)")
        Messaging.messaging().appDidReceiveMessage(userInfo)
        return .newData
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
        let type: AuthAPNSTokenType
#if DEBUG
        type = .sandbox
#else
        type = .prod
#endif
        Auth.auth().setAPNSToken(deviceToken, type: type)
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        Logger.standard.error(
            "Unable to register for remote notifications: \(error.localizedDescription)"
        )
    }

    // MARK: - UNUserNotificationCenterDelegate
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        Logger.standard.debug("\(userInfo)")
        Messaging.messaging().appDidReceiveMessage(userInfo)
        return [[.badge, .banner, .list, .sound]]
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        let userInfo = response.notification.request.content.userInfo
        Logger.standard.debug("\(userInfo)")
        Messaging.messaging().appDidReceiveMessage(userInfo)
        if let string = userInfo[fcmURLKey] as? String,
           let url = URL(string: string)
        {
            Logger.standard.debug("Opening URL: \(url)")
            await UIApplication.shared.open(url)
        }
    }

    // MARK: - MessagingDelegate
    nonisolated func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        Logger.standard.debug("Firebase registration token: \(fcmToken ?? "")")
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        Task {
            guard let fcmToken else {
                return
            }
            try await notificationService.upsertFCMToken(fcmToken)
        }
    }
}
