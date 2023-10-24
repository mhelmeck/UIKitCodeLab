//
//  WhackSlot.swift
//  Whack-a-Penguin
//
//  Created by Maciej Helmecki on 20/10/2023.
//

import SpriteKit
import UIKit

class WhackSlot: SKNode {
    // MARK: - Properites

    var isVisible = false
    var isHit = false

    let charNode: SKSpriteNode! = {
        let node = SKSpriteNode(imageNamed: "penguinGood")
        node.position = CGPoint(x: 0, y: -90)
        node.name = "character"

        return node
    }()

    private let cropNode: SKCropNode = {
        let node = SKCropNode()
        node.position = CGPoint(x: 0, y: 15)
        node.zPosition = 1
        node.maskNode = SKSpriteNode(imageNamed: "whackMask")

        return node
    }()

    // MARK: - Methods

    func configure(at position: CGPoint) {
        self.position = position

        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        cropNode.addChild(charNode)
        addChild(cropNode)
    }

    func show(hideTime: Double) {
        guard !isVisible else {
            return
        }

        charNode.xScale = 1
        charNode.yScale = 1
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible = true
        isHit = false

        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
            self?.hide()
        }
    }

    func hide() {
        guard isVisible else {
            return
        }

        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }

    func hit() {
        isHit = true

        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [unowned self] in self.isVisible = false }
        charNode.run(SKAction.sequence([delay, hide, notVisible]))
    }
}
