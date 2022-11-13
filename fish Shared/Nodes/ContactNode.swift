//
//  ContactNode.swift
//  fish
//
//  Created by Hunter Bashaw on 11/11/22.
//

import SpriteKit
import GameplayKit

class ContactNode: SKShapeNode, GKAgentDelegate {
	var agent = GKAgent2D()

	func agentWillUpdate(_ agent: GKAgent) {
		if let agent2D = agent as? GKAgent2D {
			agent2D.position = vector_float2(Float(position.x), Float(position.y))
		}
	}

	func agentDidUpdate(_ agent: GKAgent) {
		if let agent2D = agent as? GKAgent2D {
			self.position = CGPoint(x: CGFloat(agent2D.position.x), y: CGFloat(agent2D.position.y))
		}
	}
}
