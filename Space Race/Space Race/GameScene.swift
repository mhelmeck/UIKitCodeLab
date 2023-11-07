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

    // MARK: - Lifecycle

    override func didMove(to view: SKView) {
        setupView()
    }

    private func setupView() {
        backgroundColor = .black

        addSubviews()
        resetScore()
        setupPhysicsWorld()
    }

    // MARK: - Methods

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
}
