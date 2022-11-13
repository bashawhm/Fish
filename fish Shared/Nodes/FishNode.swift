//
//  FishNode.swift
//  fish
//
//  Created by Hunter Bashaw on 11/11/22.
//

import GameplayKit
import SpriteKit

class FishNode: SKShapeNode, GKAgentDelegate {
	var actor = Fish()
	var agent = GKAgent2D()
	var hungryTimer: Timer? = nil
	var deathTimer: Timer? = nil

	var stateMachine: GKStateMachine!

	func eat(value: Int) {
		becomeSatiated()
		actor.foodEaten += value
	}

	func becomeSatiated() {
		actor.component(ofType: Tracking.self)?.stopTracking()
		deathTimer?.invalidate()
		hungryTimer = Timer(timeInterval: 5.0, repeats: false, block: {(Timer) in self.becomeHungry()})
		RunLoop.main.add(hungryTimer!, forMode: RunLoop.Mode.common)
		stateMachine.enter(SatiatedState.self)
	}

	func becomeHungry() {
		hungryTimer?.invalidate()
		deathTimer = Timer(timeInterval: 10.0, repeats: false, block: {(Timer) in self.becomeDead()})
		RunLoop.main.add(deathTimer!, forMode: RunLoop.Mode.common)
		stateMachine.enter(HungryState.self)
	}

	func isHungry() -> Bool {
		return stateMachine.currentState!.isKind(of: HungryState.self)
	}

	func isTracking() -> Bool {
		if actor.component(ofType: Tracking.self) != nil {
			return actor.component(ofType: Tracking.self)!.isTracking()
		}
		return false
	}

	func becomeDead() {
		hungryTimer?.invalidate()
		deathTimer?.invalidate()
		stateMachine.enter(DeadState.self)
	}

	func agentWillUpdate(_ agent: GKAgent) {
		if let agent2D = agent as? GKAgent2D {
			agent2D.position = vector_float2(Float(position.x), Float(position.y))
		}
	}

	func agentDidUpdate(_ agent: GKAgent) {
		if let agent2D = agent as? GKAgent2D {
			position = CGPoint(x: CGFloat(agent2D.position.x), y: CGFloat(agent2D.position.y))
		}
	}
}
