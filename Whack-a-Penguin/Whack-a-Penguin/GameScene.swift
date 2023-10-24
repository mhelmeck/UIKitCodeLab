import SpriteKit

class GameScene: SKScene {
    // MARK: - Properties

    private let backgroundNode: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "whackBackground")
        node.position = CGPoint(x: 512, y: 384)
        node.blendMode = .replace
        node.zPosition = -1

        return node
    }()

    private let gameScoreLabel: SKLabelNode! = {
        let node = SKLabelNode(fontNamed: "Chalkduster")
        node.text = "Score: 0"
        node.position = CGPoint(x: 8, y: 8)
        node.horizontalAlignmentMode = .left
        node.fontSize = 48

        return node
    }()

    private var slots = [WhackSlot]()
    private var popupTime = 0.85
    private var numRounds = 0

    private var score = 0 {
        didSet {
            gameScoreLabel.text = "Score: \(score)"
        }
    }

    // MARK: - Lifecycle

    override func didMove(to view: SKView) {
        setupView()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.execudeRound()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)

        for node in tappedNodes {
            guard let whackSlot = getSlot(from: node) else {
                continue
            }

            whackSlot.hit()
            if node.name == "charFriend" {
                score -= 5
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            } else if node.name == "charEnemy" {
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                score += 1
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            }
        }
    }

    // MARK: - Methods

    private func setupView() {
        addChild(backgroundNode)
        addChild(gameScoreLabel)

        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
    }

    private func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }

    private func execudeRound() {
        numRounds += 1

        if numRounds < 30 {
            createEnemy()
        } else {
            endGame()
        }
    }

    private func endGame() {
        gameScoreLabel.isHidden = true
        for slot in slots {
            slot.hide()
        }

        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.position = CGPoint(x: 512, y: 384)
        gameOver.zPosition = 1
        addChild(gameOver)

        let finalScore = SKLabelNode(fontNamed: "Chalkduster")
        finalScore.text = "Final score: \(score)"
        finalScore.position = CGPoint(x: 512, y: 300)
        gameOver.zPosition = 1
        finalScore.horizontalAlignmentMode = .center
        finalScore.fontSize = 48
        addChild(finalScore)
    }

    private func createEnemy() {
        popupTime *= 0.991

        slots.shuffle()
        slots[0].show(hideTime: popupTime)

        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 8 {  slots[2].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popupTime)  }

        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.execudeRound()
        }
    }

    private func getSlot(from node: SKNode) -> WhackSlot? {
        guard let whackSlot = node.parent?.parent as? WhackSlot else {
            return nil
        }

        if !whackSlot.isVisible { return nil }
        if whackSlot.isHit { return nil }

        return whackSlot
    }
}
