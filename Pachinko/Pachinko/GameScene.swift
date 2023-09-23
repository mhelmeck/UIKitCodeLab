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
            ball.physicsBody?.restitution = 0.4
            ball.position = location
            
            addChild(ball)
        }
    }
    
    // MARK: - Properties
    
    private func setupView() {
        addChild(backgroundNode)
        
        [
            (x: 0, y: 0),
            (x: 256, y: 0),
            (x: 512, y: 0),
            (x: 768, y: 0),
            (x: 1024, y: 0)
        ].map(CGPoint.init).map(makeBouncer).forEach(addChild)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }
    
    private func makeBouncer(at position: CGPoint) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: "bouncer")
        node.position = position
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2.0)
        node.physicsBody?.isDynamic = false
        
        return node
    }
}

private extension CGPoint {
    init(coord: (x: CGFloat, y: CGFloat)) {
        self.init()
        
        x = coord.x
        y = coord.y
    }
}
