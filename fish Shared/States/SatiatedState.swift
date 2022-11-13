//
//  HungerState.swift
//  fish
//
//  Created by Hunter Bashaw on 11/11/22.
//

import GameplayKit
import SpriteKit

class SatiatedState: GKState {
	var node: FishNode

	init(withNode: FishNode) {
		node = withNode
	}

	override func isValidNextState(_ stateClass: AnyClass) -> Bool {
		switch stateClass {
		case is HungryState.Type:
			return true

		default:
			return false

		}
	}

	override func didEnter(from previousState: GKState?) {
		if let _ = previousState as? HungryState {
			// Run code to change texture
			node.fillColor = .orange
		} else if let _ = previousState as? DeadState {
			// Run code to change texture
			node.fillColor = .orange
		}
	}
}
