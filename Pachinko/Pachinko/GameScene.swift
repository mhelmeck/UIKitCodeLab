import SpriteKit

class GameScene: SKScene {
    // MARK: - Properties
    
    let backgroundNode: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "background.jpg")
        node.position = CGPoint(x: 512, y: 384)
        node.blendMode = .replace
        node.zPosition = -1
        
        return node
    }()
    
    // MARK: - Lifecycle
    
    override func didMove(to view: SKView) {
        setupView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let ball = SKSpriteNode(imageNamed: "ballRed")
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
            ball.physicsBody!.restitution = 0.4
            ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
            ball.position = location
            ball.name = "ball"
            
            
            addChild(ball)
        }
    }
    
    // MARK: - Properties
    
    private func setupView() {
        addChild(backgroundNode)
        
        let bouncerCoords = [ (x: 0, y: 0), (x: 256, y: 0), (x: 512, y: 0), (x: 768, y: 0), (x: 1024, y: 0)]
        let slotCoords = [ (x: 128, y: 0), (x: 384, y: 0), (x: 640, y: 0), (x: 896, y: 0)]
            
        bouncerCoords
            .map(CGPoint.init)
            .forEach(addBouncer)
        slotCoords
            .map(CGPoint.init)
            .enumerated()
            .forEach(addSlot)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
    }
    
    private func addBouncer(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "bouncer")
        node.position = position
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2.0)
        node.physicsBody?.isDynamic = false
        
        addChild(node)
    }
    
    private func addSlot(details: (offset: Int, element: CGPoint)) {
        let position = details.element
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode

        if details.offset % 2 == 0 {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.position = position
        slotGlow.run(spinForever)
        
        addChild(slotBase)
        addChild(slotGlow)
    }
    
    private func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
        } else if object.name == "bad" {
            destroy(ball: ball)
        }
    }

    private func destroy(ball: SKNode) {
        ball.removeFromParent()
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
}

private extension CGPoint {
    init(coord: (x: CGFloat, y: CGFloat)) {
        self.init()
        
        x = coord.x
        y = coord.y
    }
}
