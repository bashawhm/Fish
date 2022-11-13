//
//  DropNode.swift
//  fish
//
//  Created by Hunter Bashaw on 11/12/22.
//

import GameplayKit
import SpriteKit

class DropNode: SKShapeNode, GKAgentDelegate {
	var actor = Drop()
	var agent = GKAgent2D()

	func isFood() -> Bool {
		if actor.component(ofType: Food.self) != nil {
			return true
		}
		return false
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
