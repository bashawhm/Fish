//
//  Tracking.swift
//  fish
//
//  Created by Hunter Bashaw on 11/13/22.
//

import GameplayKit
import SpriteKit

class Tracking: GKComponent {
	var myself: GKAgent!
	var tracking: GKAgent? = nil
	var trackingGoal: GKGoal? = nil

	func startTracking(agent: GKAgent) {
		tracking = agent
		trackingGoal = GKGoal(toInterceptAgent: tracking!, maxPredictionTime: 2)

		myself.behavior!.setWeight(1.0, for: trackingGoal!)
	}

	func stopTracking() {
		if trackingGoal != nil {
			myself.behavior!.remove(trackingGoal!)
		}
		tracking = nil
	}

	func isTracking() -> Bool {
		if tracking != nil {
			return true
		}
		return false
	}
}
