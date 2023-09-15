import SnapKit
import UIKit

class ViewController: UIViewController {
    // MARK: - Properties
    
    let cluesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "CLUES"
        label.numberOfLines = 0
        
        return label
    }()
    
    let answersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "ANSWERS"
        label.numberOfLines = 0
        label.textAlignment = .right
        
        return label
    }()
    
    let currentAnswer: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Tap letters to guess"
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 44)
        textField.isUserInteractionEnabled = false
        
        return textField
    }()
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.text = "Score: 0"
        
        return label
    }()
    
    let submit: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SUBMIT", for: .normal)
        
        return button
    }()
    
    let clear: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CLEAR", for: .normal)
        
        return button
    }()
    
    var letterButtons = [UIButton]()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white

        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Methods
    
    private func setupView() {
        [
            scoreLabel,
            cluesLabel,
            answersLabel,
            currentAnswer,
            submit,
            clear
        ].forEach(view.addSubview)
        
        installContraints()
    }
    
    private func installContraints() {
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
    }
}
