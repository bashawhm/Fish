//
//  HungryState.swift
//  fish
//
//  Created by Hunter Bashaw on 11/11/22.
//

import GameplayKit
import SpriteKit

class HungryState: GKState {
	var node: FishNode

	init(withNode: FishNode) {
		node = withNode
	}

	override func isValidNextState(_ stateClass: AnyClass) -> Bool {
		switch stateClass {
		case is SatiatedState.Type:
			return true
		case is DeadState.Type:
			return true

		default:
			return false

		}
	}

	override func didEnter(from previousState: GKState?) {
		if let _ = previousState as? SatiatedState {
			// Run code to change texture
			node.fillColor = .green
		}
	}
}

