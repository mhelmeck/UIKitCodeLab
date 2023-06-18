//
//  ViewController.swift
//  Guess The Flag
//
//  Created by Maciej Helmecki on 16/06/2023.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    // MARK: - Properties
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20.0
        
        return view
    }()
    
    private let flagOne: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.tag = 0
        
        return button
    }()
    
    private let flagTwo: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.tag = 1
        
        return button
    }()
    
    private let flagThree: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.tag = 2
        
        return button
    }()
    
    private var countries = [String]()
    private var score = 0
    private var correctAnswer = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        loadData()
        askQuestion()
    }
    
    // MARK: - Methods
    private func setupView() {
        view.backgroundColor = .white
        
        flagOne.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        flagTwo.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        flagThree.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        view.addSubview(stackView)
        [flagOne, flagTwo, flagThree].forEach(stackView.addArrangedSubview)
        
        installConstraints()
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score -= 1
        }
        
        let alertVC = UIAlertController(
            title: title,
            message: "Your score is \(score).",
            preferredStyle: .alert
        )
        alertVC.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        
        present(alertVC, animated: true)
    }
    
    private func installConstraints() {
        stackView.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
    }
    
    private func loadData() {
        [
            "estonia",
            "france",
            "germany",
            "ireland",
            "italy",
            "monaco",
            "nigeria",
            "poland",
            "russia",
            "spain",
            "uk",
            "us"
        ].forEach( { countries.append($0) })
    }
    
    private func askQuestion(action: UIAlertAction? = nil) {
        countries.shuffle()
        
        flagOne.setBackgroundImage(UIImage(named: countries[0]), for: .normal)
        flagTwo.setBackgroundImage(UIImage(named: countries[1]), for: .normal)
        flagThree.setBackgroundImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        title = countries[correctAnswer].uppercased()
    }
}
