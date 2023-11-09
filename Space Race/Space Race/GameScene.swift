import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    // MARK: - Properties

    private let starfield: SKEmitterNode = {
        let node = SKEmitterNode(fileNamed: "starfield")!
        node.position = CGPoint(x: 1024, y: 384)
        node.advanceSimulationTime(10)
        node.zPosition = -1

        return node
    }()

    private let player: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "player")
        node.position = CGPoint(x: 100, y: 384)
        node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.size)
        node.physicsBody?.contactTestBitMask = 1

        return node
    }()

    private let scoreLabel: SKLabelNode = {
        let node = SKLabelNode(fontNamed: "Chalkduster")
        node.position = CGPoint(x: 16, y: 16)
        node.horizontalAlignmentMode = .left

        return node
    }()

    private var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    private let possibleEnemies = ["ball", "hammer", "tv"]
    private var isGameOver = false
    private var gameTimer: Timer?

    // MARK: - Lifecycle

    override func didMove(to view: SKView) {
        setupView()
        resetScore()
        setupPhysicsWorld()
        setupTimer()
    }

    // MARK: - Methods

    private func setupView() {
        backgroundColor = .black
        addSubviews()
    }

    private func addSubviews() {
        addChild(starfield)
        addChild(player)
        addChild(scoreLabel)
    }

    private func resetScore() {
        score = 0
    }

    private func setupPhysicsWorld() {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
    }

    private func setupTimer() {
        gameTimer = Timer.scheduledTimer(
            timeInterval: 0.35,
            target: self,
            selector: #selector(createEnemy),
            userInfo: nil,
            repeats: true
        )
    }

    @objc private func createEnemy() {
        guard let enemy = possibleEnemies.randomElement() else { 
            return
        }

        let node = SKSpriteNode(imageNamed: enemy)
        node.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(node)

        node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.size)
        node.physicsBody?.categoryBitMask = 1
        node.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        node.physicsBody?.angularVelocity = 5
        node.physicsBody?.linearDamping = 0
        node.physicsBody?.angularDamping = 0
    }
}
