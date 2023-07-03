//
//  HomeViewController.swift
//  Guess The Flag
//
//  Created by Maciej Helmecki on 16/06/2023.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
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
    private var scores = [Int]()
    private var correctAnswer = 0

    private var score: Int {
        scores.reduce(0, +)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        loadData()
        play()
    }
    
    // MARK: - Methods
    private func setupView() {
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(shareTapped))
        
        flagOne.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        flagTwo.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        flagThree.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        view.addSubview(stackView)
        [flagOne, flagTwo, flagThree].forEach(stackView.addArrangedSubview)
        
        installConstraints()
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        var title: String
        var message: String
        
        if sender.tag == correctAnswer {
            scores.append(1)
            
            title = "Correct"
            message = "Your score is: \(score)"
        } else {
            scores.append(-1)
            
            title = "Wrong"
            message = "That’s the flag of \(countries[sender.tag].capitalized) Your score is: \(score)"
        }
        
        let alertVC = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertVC.addAction(UIAlertAction(title: "Continue", style: .default, handler: play))
        
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
    
    private func play(action: UIAlertAction? = nil) {
        if scores.count == 5 {
            reset()
        } else {
            askQuestion()
        }
    }
        
    private func askQuestion() {
        countries.shuffle()
        
        flagOne.setBackgroundImage(UIImage(named: countries[0]), for: .normal)
        flagTwo.setBackgroundImage(UIImage(named: countries[1]), for: .normal)
        flagThree.setBackgroundImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        
        title = "Guess: \(countries[correctAnswer].capitalized)"
    }
    
    private func reset() {
        title = ""
        
        let alertVC = UIAlertController(
            title: "Congratulations!",
            message: "You've finished game with score: \(score).",
            preferredStyle: .alert
        )
        alertVC.addAction(UIAlertAction(title: "Play again", style: .default, handler: { [weak self] _ in
            self?.scores = []
            self?.play()
        }))
        
        present(alertVC, animated: true)
    }
    
    @objc private func shareTapped() {
        let alertVC = UIAlertController(
            title: "Current score!",
            message: "\(score)",
            preferredStyle: .alert
        )
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default))
        
        present(alertVC, animated: true)
    }
}
