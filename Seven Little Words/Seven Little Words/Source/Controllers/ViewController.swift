import SnapKit
import UIKit

class ViewController: UIViewController {
    // MARK: - Properties
    
    private let levelService = LevelService()
    
    private let cluesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "CLUES"
        label.numberOfLines = 0
        
        return label
    }()
    
    private let answersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "ANSWERS"
        label.numberOfLines = 0
        label.textAlignment = .right
        
        return label
    }()
    
    private let currentAnswer: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Tap letters to guess"
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 44)
        textField.isUserInteractionEnabled = false
        
        return textField
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.text = "Score: 0"
        
        return label
    }()
    
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "Level: 1"
        
        return label
    }()
    
    private let submit: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SUBMIT", for: .normal)
        
        return button
    }()
    
    private let clear: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CLEAR", for: .normal)
        
        return button
    }()
    
    private let buttonsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16.0
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.lightGray.cgColor
        
        return view
    }()
    
    private var letterButtons = [UIButton]()
    private var activatedButtons = [UIButton]()
    private var solutions = [String]()

    private var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    private var level = 1 {
        didSet {
            levelLabel.text = "Level: \(level)"
        }
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white

        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLevel()
    }

    // MARK: - Methods
    
    private func setupView() {
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        
        [
            levelLabel,
            scoreLabel,
            cluesLabel,
            answersLabel,
            currentAnswer,
            submit,
            clear,
            buttonsView
        ].forEach(view.addSubview)
        
        installContraints()
        setupButtons()
    }
    
    private func installContraints() {
        levelLabel.snp.makeConstraints {
            $0.top.leading.equalTo(view.layoutMarginsGuide)
        }
        
        scoreLabel.snp.makeConstraints {
            $0.top.trailing.equalTo(view.layoutMarginsGuide)
        }
        
        cluesLabel.snp.makeConstraints {
            $0.top.equalTo(scoreLabel.snp.bottom)
            $0.leading.equalTo(view.layoutMarginsGuide).offset(100.0)
            $0.width.equalTo(view.layoutMarginsGuide).multipliedBy(0.6).offset(-100.0)
        }
        
        answersLabel.snp.makeConstraints {
            $0.top.equalTo(scoreLabel.snp.bottom)
            $0.trailing.equalTo(view.layoutMarginsGuide).offset(-100.0)
            $0.width.equalTo(view.layoutMarginsGuide).multipliedBy(0.4).offset(-100.0)
            $0.height.equalTo(cluesLabel.snp.height)
        }
        
        currentAnswer.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.width.equalTo(view).multipliedBy(0.5)
            $0.top.equalTo(cluesLabel.snp.bottom).offset(20.0)
        }
        
        submit.snp.makeConstraints {
            $0.top.equalTo(currentAnswer.snp.bottom)
            $0.centerX.equalTo(view).offset(-100.0)
            $0.height.equalTo(44.0)
        }
        
        clear.snp.makeConstraints {
            $0.centerX.equalTo(view).offset(100.0)
            $0.centerY.equalTo(submit.snp.centerY)
            $0.height.equalTo(44.0)
        }
        
        buttonsView.snp.makeConstraints {
            $0.width.equalTo(750.0)
            $0.height.equalTo(320.0)
            $0.centerX.equalTo(view)
            $0.top.equalTo(submit.snp.bottom).offset(20.0)
            $0.bottom.equalTo(view.layoutMarginsGuide).offset(-20.0)
        }
    }
    
    private func setupButtons() {
        let width = 150.0
        let height = 80.0
        
        for row in 0..<4 {
            for col in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)

                letterButton.setTitle("WWW", for: .normal)

                let frame = CGRect(
                    x: Double(col) * width,
                    y: Double(row) * height,
                    width: width,
                    height: height
                )
                letterButton.frame = frame
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
    }
    
    private func loadLevel() {
        guard let level = levelService.load(level: level) else {
            return
        }
        
        solutions = level.solutions
        cluesLabel.text = level.clueString
        answersLabel.text = level.solutionString

        if level.letterBits.count == letterButtons.count {
            for i in 0 ..< letterButtons.count {
                letterButtons[i].setTitle(level.letterBits[i], for: .normal)
                letterButtons[i].isHidden = false
            }
        }
    }
    
    private func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)

        loadLevel()
    }
    
    @objc private func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { 
            return
        }
        
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }

    @objc private func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else {
            return
        }
        
        guard let solutionPosition = solutions.firstIndex(of: answerText) else {
            if score > 0 { score -= 1 }
            
            let ac = UIAlertController(title: "Ups!", message: "Are you wrong", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Try again", style: .default))
            present(ac, animated: true)
            
            return
        }
        
        activatedButtons.removeAll()

        var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
        splitAnswers?[solutionPosition] = answerText
        answersLabel.text = splitAnswers?.joined(separator: "\n")

        currentAnswer.text = ""
        score += 1

        if letterButtons.allSatisfy({ $0.isHidden }) {
            let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
            present(ac, animated: true)
        }
    }

    @objc private func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""

        for btn in activatedButtons {
            btn.isHidden = false
        }

        activatedButtons.removeAll()
    }
}
