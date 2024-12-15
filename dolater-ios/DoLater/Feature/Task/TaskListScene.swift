//
//  TaskListScene.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import CoreMotion
import Observation
import SpriteKit

@Observable
final class TaskListScene<Environment: EnvironmentProtocol>: SKScene, Sendable {
    var binPosition: CGPoint = .init(x: 0, y: 0)
    var trashPositions: [String:CGPoint] = [:]
    var trashRotations: [String:CGFloat] = [:]

    private let motionManager: CMMotionManager = .init()

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        motionManager.startAccelerometerUpdates()
    }

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if let node = childNode(withName: "bin") {
            binPosition = node.position
        }
        children.forEach { node in
            if let name = node.name {
                trashPositions[name] = node.position
                trashRotations[name] = node.zRotation
            }
        }
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(
                dx: accelerometerData.acceleration.x * 9.8,
                dy: accelerometerData.acceleration.y * 9.8
            )
        }
    }

    func addBinNode(radius: CGFloat) {
        let node = SKShapeNode(circleOfRadius: radius)
        node.name = "bin"
        node.position = CGPoint(x: frame.minX + radius, y: frame.minY)
        node.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        node.strokeColor = .clear
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.isDynamic = false
        addChild(node)
        binPosition = node.position
    }

    func addTaskNode(for task: DLTask) {
        let node = SKShapeNode(circleOfRadius: task.radius)
        node.name = task.displayName
        node.position = CGPoint(x: frame.midX, y: frame.midY)
        node.physicsBody = SKPhysicsBody(circleOfRadius: task.radius)
        node.strokeColor = .clear
        addChild(node)
        trashPositions[node.name ?? ""] = node.position
        trashRotations[node.name ?? ""] = node.zRotation
        addShakeAction(for: node)
    }

    func addShakeAction(for node: SKNode) {
        let clockwiseAction = SKAction.rotate(byAngle: .pi / 180, duration: 0.1)
        let counterClockwiseAction = SKAction.rotate(byAngle: -.pi / 180, duration: 0.1)
        let allAction = SKAction.sequence([clockwiseAction, counterClockwiseAction])
        let actionLoop = SKAction.repeatForever(allAction)
        node.run(actionLoop)
    }

    func removeBinNode() {
        childNode(withName: "bin")?.removeFromParent()
    }

    func removeTrashNode(for task: DLTask) {
        guard let node = childNode(withName: task.displayName) else {
            return
        }
        trashPositions.removeValue(forKey: node.name ?? "")
        trashRotations.removeValue(forKey: node.name ?? "")
        node.removeFromParent()
    }

    func removeTrashNodes() {
        for child in children {
            guard child.name?.hasPrefix(DLTask.namePrefix) ?? false else {
                continue
            }
            child.removeFromParent()
            trashPositions.removeValue(forKey: child.name ?? "")
            trashRotations.removeValue(forKey: child.name ?? "")
        }
    }
}
