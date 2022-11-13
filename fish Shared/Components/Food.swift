//
//  FishFood.swift
//  fish
//
//  Created by Hunter Bashaw on 11/13/22.
//

import GameplayKit
import SpriteKit

class Food: GKComponent {
	var myself: SKNode!
	let foodValue: Int

	init(foodValue: Int) {
		self.foodValue = foodValue
		super.init()
	}

	required init?(coder: NSCoder) {
		abort()
	}

	func beEaten() -> Int {
		return foodValue
	}

}
