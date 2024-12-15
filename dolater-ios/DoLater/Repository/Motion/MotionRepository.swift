//
//  MotionRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/12/24.
//

import AudioToolbox
import CoreMotion

protocol MotionRepositoryProtocol: Actor {
    func startMonitoringDeviceMotion()

    func stopMonitoringDeviceMotion()

    func startVibration()

    func stopVibration()
}

final actor MotionRepositoryImpl: MotionRepositoryProtocol {
    private let motionManager: CMMotionManager = .init()
    private var vibrationTimer: Timer?

    private var motionStreamContinuation: AsyncStream<CMDeviceMotion?>.Continuation?
    var motionStream: AsyncStream<CMDeviceMotion?> {
        AsyncStream { continuation in
            motionStreamContinuation = continuation
        }
    }

    func startMonitoringDeviceMotion() {
        guard motionManager.isDeviceMotionAvailable else {
            return
        }
        motionManager.accelerometerUpdateInterval = 1 / 60
        let operationQueue = OperationQueue.current ?? OperationQueue()
        motionManager.startDeviceMotionUpdates(to: operationQueue) { [weak self] motion, error in
            if let error {
                Logger.standard.error("\(error)")
                return
            }
            Task { [weak self] in
                await self?.motionStreamContinuation?.yield(motion)
            }
        }
    }

    func stopMonitoringDeviceMotion() {
        guard motionManager.isDeviceMotionActive else {
            return
        }
        motionManager.stopDeviceMotionUpdates()
    }

    func startVibration() {
        vibrationTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
    }

    func stopVibration() {
        vibrationTimer?.invalidate()
        vibrationTimer = nil
    }
}

extension CMDeviceMotion: @retroactive @unchecked Sendable {}

extension AsyncStream<CMDeviceMotion?>.Continuation.YieldResult: @retroactive @unchecked Sendable {}
