//
//  GameViewController.swift
//  fish macOS
//
//  Created by Hunter Bashaw on 11/11/22.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Present the scene
        let skView = self.view as! SKView
		let scene = GameScene(size: skView.bounds.size)
		scene.scaleMode = .aspectFit
//		skView.showsPhysics = true
        skView.presentScene(scene)

        skView.ignoresSiblingOrder = true

        skView.showsFPS = true
        skView.showsNodeCount = true
    }

}

