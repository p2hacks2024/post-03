//
//  Environment.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

protocol EnvironmentProtocol: Actor {
    static var shared: Self { get }

    var appCheckRepository: AppCheckRepositoryProtocol { get }
    var authRepository: AuthRepositoryProtocol { get }
    var httpRepository: HTTPRepositoryProtocol { get }
    var localRepository: LocalRepositoryProtocol { get }
    var motionRepository: MotionRepositoryProtocol { get }
    var notificationRepository: NotificationRepositoryProtocol { get }
    var remoteConfigRepository: RemoteConfigRepositoryProtocol { get }
    var storageRepository: StorageRepositoryProtocol { get }
    var taskPoolRepository: TaskPoolRepositoryProtocol { get }
    var taskRepository: TaskRepositoryProtocol { get }
    var userRepository: UserRepositoryProtocol { get }
}

final actor EnvironmentImpl: EnvironmentProtocol {
    static let shared: EnvironmentImpl = .init()

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
        appCheckRepository: any AppCheckRepositoryProtocol = AppCheckRepositoryImpl(),
        authRepository: any AuthRepositoryProtocol = AuthRepositoryImpl(),
        httpRepository: any HTTPRepositoryProtocol = HTTPRepositoryImpl(),
        localRepository: any LocalRepositoryProtocol = LocalRepositoryImpl(),
        motionRepository: any MotionRepositoryProtocol = MotionRepositoryImpl(),
        notificationRepository: any NotificationRepositoryProtocol = NotificationRepositoryImpl(),
        remoteConfigRepository: any RemoteConfigRepositoryProtocol = RemoteConfigRepositoryImpl(),
        storageRepository: any StorageRepositoryProtocol = StorageRepositoryImpl(),
        taskPoolRepository: any TaskPoolRepositoryProtocol = TaskPoolRepositoryImpl(),
        taskRepository: any TaskRepositoryProtocol = TaskRepositoryImpl(),
        userRepository: any UserRepositoryProtocol = UserRepositoryImpl()
    ) {
        self.appCheckRepository = appCheckRepository
        self.authRepository = authRepository
        self.httpRepository = httpRepository
        self.localRepository = localRepository
        self.motionRepository = motionRepository
        self.notificationRepository = notificationRepository
        self.remoteConfigRepository = remoteConfigRepository
        self.storageRepository = storageRepository
        self.taskPoolRepository = taskPoolRepository
        self.taskRepository = taskRepository
        self.userRepository = userRepository
    }
}
