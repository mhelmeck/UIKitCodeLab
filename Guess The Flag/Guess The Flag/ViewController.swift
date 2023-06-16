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
    
    private let flagOne: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        
        return button
    }()
    
    private let flagTwo: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        
        return button
    }()
    
    private let flagThree: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderWidth = 1    
        button.layer.borderColor = UIColor.lightGray.cgColor
        
        return button
    }()
    
    private var countries = [String]()
    private var score = 0
    
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
        
        [flagOne, flagTwo, flagThree].forEach(view.addSubview)
        
        installConstraints()
    }
    
    private func installConstraints() {
        flagOne.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100.0)
            $0.centerX.equalToSuperview()
        }
        
        flagTwo.snp.makeConstraints {
            $0.top.equalToSuperview().offset(230.0)
            $0.centerX.equalToSuperview()
        }
        
        flagThree.snp.makeConstraints {
            $0.top.equalToSuperview().offset(360.0)
            $0.centerX.equalToSuperview()
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
    
    private func askQuestion() {
        flagOne.setBackgroundImage(UIImage(named: countries[0]), for: .normal)
        flagTwo.setBackgroundImage(UIImage(named: countries[1]), for: .normal)
        flagThree.setBackgroundImage(UIImage(named: countries[2]), for: .normal)
    }
}
