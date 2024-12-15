//
//  MockEnvironment.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import Foundation

final actor MockEnvironment: EnvironmentProtocol {
    static let shared: MockEnvironment = .init()

    let appCheckRepository: any AppCheckRepositoryProtocol
    let authRepository: any AuthRepositoryProtocol
    let httpRepository: any HTTPRepositoryProtocol
    let localRepository: any LocalRepositoryProtocol
    let motionRepository: any MotionRepositoryProtocol
    let notificationRepository: any NotificationRepositoryProtocol
    let remoteConfigRepository: any RemoteConfigRepositoryProtocol
    let storageRepository: any StorageRepositoryProtocol
    let taskPoolRepository: any TaskPoolRepositoryProtocol
    let taskRepository: any TaskRepositoryProtocol
    let userRepository: any UserRepositoryProtocol

    init(
        appCheckRepository: any AppCheckRepositoryProtocol = MockAppCheckRepository(),
        authRepository: any AuthRepositoryProtocol = MockAuthRepository(),
        httpRepository: any HTTPRepositoryProtocol = MockHTTPRepository(),
        localRepository: any LocalRepositoryProtocol = MockLocalRepository(),
        motionRepository: any MotionRepositoryProtocol = MockMotionRepository(),
        notificationRepository: any NotificationRepositoryProtocol = MockNotificationRepository(),
        remoteConfigRepository: any RemoteConfigRepositoryProtocol = MockRemoteConfigRepository(),
        storageRepository: any StorageRepositoryProtocol = MockStorageRepository(),
        taskPoolRepository: any TaskPoolRepositoryProtocol = MockTaskPoolRepository(),
        taskRepository: any TaskRepositoryProtocol = MockTaskRepository(),
        userRepository: any UserRepositoryProtocol = MockUserRepository()
    ) {
        self.appCheckRepository = appCheckRepository
        self.authRepository = authRepository
        self.httpRepository = httpRepository
        self.localRepository = localRepository
        self.motionRepository = motionRepository
        self.notificationRepository = notificationRepository
        self.remoteConfigRepository = remoteConfigRepository
        self.storageRepository = storageRepository
        self.userRepository = userRepository
        self.taskPoolRepository = taskPoolRepository
        self.taskRepository = taskRepository
    }
}
