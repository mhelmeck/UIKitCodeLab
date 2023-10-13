import SpriteKit

class GameScene: SKScene {
    // MARK: - Properties
    
    private let backgroundNode: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "background.jpg")
        node.position = CGPoint(x: 512, y: 384)
        node.blendMode = .replace
        node.zPosition = -1
        
        return node
    }()
    
    private let scoreLabel: SKLabelNode = {
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Score: 0"
        label.horizontalAlignmentMode = .right
        label.position = CGPoint(x: 980, y: 700)
        
        return label
    }()
    
    private let ballsLeftLabel: SKLabelNode = {
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Balls left: 5"
        label.horizontalAlignmentMode = .right
        label.position = CGPoint(x: 790, y: 700)
        
        return label
    }()
    
    private let editLabel: SKLabelNode = {
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Editing, tap to play"
        label.position = CGPoint(x: 220, y: 700)
        
        return label
    }()
    
    private let restartLabel: SKLabelNode = {
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Restart"
        label.position = CGPoint(x: 104, y: 640)
        
        return label
    }()
    
    private let dividerNode: SKSpriteNode = {
        let size = CGSize(width: 1024, height: 2)
        let node = SKSpriteNode(color: .lightGray, size: size)
        node.zRotation = 0.0
        node.blendMode = .replace
        node.position = CGPoint(x: 512, y: 384)
        
        return node
    }()
    
    private var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    private var maximumBalls = 5 {
        didSet {
            ballsLeftLabel.text = "Balls left: \(maximumBalls)"
        }
    }
    
    private var editingMode: Bool = true {
        didSet {
            if editingMode {
                editLabel.text = "Editing, tap to play"
            } else {
                editLabel.text = "Playing, tap to edit"
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func didMove(to view: SKView) {
        setupView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        let location = touch.location(in: self)
        let objects = nodes(at: location)

        if objects.contains(editLabel) {
            didTouchEditLabel()
        } else if objects.contains(restartLabel) {
            didTouchRestartLabel()
        } else {
            didTouchOtherObject(at: location)
        }
    }

    private func didTouchEditLabel() {
        editingMode.toggle()
    }

    private func didTouchRestartLabel() {
        resetGame()
    }

    private func didTouchOtherObject(at location: CGPoint) {
        if editingMode {
            addBoxIfNeeded(at: location)
        } else {
            addBallIfNeeded(at: location)
        }
    }

    private func addBoxIfNeeded(at location: CGPoint) {
        guard location.y < 384 else { return }

        let box = createBox(at: location)
        addChild(box)
    }

    private func createBox(at location: CGPoint) -> SKSpriteNode {
        let size = CGSize(width: Int.random(in: 16...128), height: 16)
        let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
        box.zRotation = CGFloat.random(in: 0...3)
        box.position = location
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody?.isDynamic = false
        box.name = "box"

        return box
    }

    private func addBallIfNeeded(at location: CGPoint) {
        guard location.y > 384 else { return }
        guard maximumBalls > 0 else { return }

        reduceMaximumBalls()

        let ball = createBall(at: location)
        addChild(ball)
    }

    private func reduceMaximumBalls() {
        maximumBalls -= 1
    }

    private func createBall(at location: CGPoint) -> SKSpriteNode {
        let imageName = ["ballGrey", "ballPurple", "ballRed", "ballCyan", "ballYellow", "ballGreen", "ballBlue"].randomElement() ?? "ballRed"
        let ball = SKSpriteNode(imageNamed: imageName)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
        ball.physicsBody!.restitution = 0.4
        ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
        ball.position = location
        ball.name = "ball"

        return ball
    }

    // MARK: - Methods
    
    private func setupView() {
        addSubviews()
        addPhysics()
    }

    private func addSubviews() {
        let bouncerCoordinates = [ (x: 0, y: 0), (x: 256, y: 0), (x: 512, y: 0), (x: 768, y: 0), (x: 1024, y: 0)]
        let slotCoordinates = [ (x: 128, y: 0), (x: 384, y: 0), (x: 640, y: 0), (x: 896, y: 0)]

        addChild(backgroundNode)
        addChild(dividerNode)
        bouncerCoordinates
            .map(CGPoint.init)
            .forEach(addBouncer)
        slotCoordinates
            .map(CGPoint.init)
            .enumerated()
            .forEach(addSlot)
        addChild(editLabel)
        addChild(restartLabel)
        addChild(ballsLeftLabel)
        addChild(scoreLabel)
    }

    private func addPhysics() {
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
            maximumBalls += 1
            destroy(ball: ball)
        } else if object.name == "bad" {
            destroy(ball: ball)
        } else if object.name == "box" {
            score += 1
            object.removeFromParent()
        }
    }

    private func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }

        ball.removeFromParent()
    }
    
    private func resetGame() {
        children.filter { $0.name == "box" || $0.name == "ball" }.forEach { $0.removeFromParent() }
        
        score = 0
        maximumBalls = 5
        editingMode = true
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
