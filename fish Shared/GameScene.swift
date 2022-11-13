//
//  GameScene.swift
//  fish Shared
//
//  Created by Hunter Bashaw on 11/11/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

	let worldNode = SKNode()
	var fishs: [FishNode] = []
	var drops: [DropNode] = []

	var lastUpdateTime: CFTimeInterval = 0.0

	func spawnFish() {
		let fish = FishNode(circleOfRadius: 50)
		fish.position = CGPoint(x: size.width / 2, y: size.height / 2)
		fish.fillColor = .orange
		fish.lineWidth = 0.0

		let fishBody = SKPhysicsBody(circleOfRadius: 50)
		fishBody.contactTestBitMask = 1
		fish.physicsBody = fishBody
		fish.physicsBody?.usesPreciseCollisionDetection = true

		fish.stateMachine = GKStateMachine(states: [SatiatedState(withNode: fish), HungryState(withNode: fish), DeadState(withNode: fish)])
		fish.becomeSatiated()

		fish.actor.addComponent(fish.agent)
		fish.agent.delegate = fish

		let fishBehavior = GKBehavior(goals: [GKGoal(toWander: 50.0)], andWeights: [0.5])
		fish.agent.behavior = fishBehavior

		fish.agent.mass = 0.01
		fish.agent.maxSpeed = 50
		fish.agent.maxAcceleration = 1000

		let trackingComponent = Tracking()
		trackingComponent.myself = fish.agent
		fish.actor.addComponent(trackingComponent)

		fishs.append(fish)
		addChild(fish)
	}

	func spawnFishFood(location: CGPoint) {
		let drop = DropNode(circleOfRadius: 10)
		drop.position = location
		drop.fillColor = .brown
		drop.lineWidth = 0.0

		let dropBody = SKPhysicsBody(circleOfRadius: 10)
		dropBody.contactTestBitMask = 1
		drop.physicsBody = dropBody
		drop.physicsBody?.usesPreciseCollisionDetection = true

		drop.actor.addComponent(drop.agent)
		drop.agent.delegate = drop

		let foodComp = Food(foodValue: 1)
		foodComp.myself = drop
		drop.actor.addComponent(foodComp)

		drop.agent.mass = 10

		drops.append(drop)
		addChild(drop)
	}

	override func didMove(to view: SKView) {
		addChild(worldNode)
		physicsWorld.gravity = CGVector(dx: 0, dy: 0)
		physicsWorld.contactDelegate = self

		let playableRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		let boundaryBox = SKShapeNode(rect: playableRect)
		boundaryBox.strokeColor = .clear
		boundaryBox.lineWidth = 4.0

		boundaryBox.physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect) // Traps everyone within the window bounds
		addChild(boundaryBox)

		spawnFish()
	}

	override func update(_ currentTime: TimeInterval) {
		// Called before each frame is rendered
		if lastUpdateTime == 0 {
			lastUpdateTime = currentTime
		}

		let delta = currentTime - lastUpdateTime
		lastUpdateTime = currentTime

		for fish in fishs {
			if fish.isHungry() && !(fish.isTracking()) {
				var closestDrop: DropNode? = nil
				var minDistance = INT_MAX
				for drop in drops {
					let xDistance = abs(drop.position.x - fish.position.x)
					let yDistance = abs(drop.position.y - fish.position.y)
					if minDistance > Int(xDistance + yDistance) {
						minDistance = Int32(xDistance + yDistance)
						closestDrop = drop
					}
				}

				if closestDrop != nil {
					if fish.intersects(closestDrop!) {
						let _ = tryEat(eater: fish, edible: closestDrop!)
					} else {
						fish.actor.component(ofType: Tracking.self)!.startTracking(agent: closestDrop!.agent)
					}
				}
			}

			fish.agent.update(deltaTime: delta)
		}

		for drop in drops {
			drop.agent.update(deltaTime: delta)
		}
	}

	func didBegin(_ contact: SKPhysicsContact) {
		let nodeA = contact.bodyA.node
		let nodeB = contact.bodyB.node

		if nodeA!.isKind(of: FishNode.self) && nodeB!.isKind(of: DropNode.self) {
			let _ = tryEat(eater: nodeA! as! FishNode, edible: nodeB! as! DropNode)
		} else if nodeB!.isKind(of: FishNode.self) && nodeA!.isKind(of: DropNode.self) {
			let _ = tryEat(eater: nodeB! as! FishNode, edible: nodeA! as! DropNode)
		}
	}

	func didEnd(_ contact: SKPhysicsContact) {

	}

	func tryEat(eater: FishNode, edible: DropNode) -> Bool {
		if eater.isHungry() && edible.isFood() {
			let foodVal = edible.actor.component(ofType: Food.self)!.beEaten()
			eater.eat(value: foodVal)
			edible.removeFromParent()
			drops.remove(at: drops.firstIndex(of: edible)!)
			return true
		}

		return false
	}

	func resetTrackingGoals() {
		for fish in fishs {
			if fish.isTracking() {
				fish.actor.component(ofType: Tracking.self)!.stopTracking()
			}
		}
	}
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches {

		}
	}

	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches {

		}
	}

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches {

		}
	}

	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches {

		}
	}
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {

	override func mouseDown(with event: NSEvent) {

	}

	override func mouseDragged(with event: NSEvent) {

	}

	override func mouseUp(with event: NSEvent) {
		spawnFishFood(location: event.location(in: self))
		resetTrackingGoals()
	}

}
#endif

