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
        button.setBackgroundImage(UIImage(named: "us"), for: .normal)
        
        return button
    }()
    
    private let flagTwo: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "uk"), for: .normal)
        
        return button
    }()
    
    private let flagThree: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "spain"), for: .normal)
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - Methods
    private func setupView() {
        view.backgroundColor = .white
        
        [flagOne, flagTwo, flagThree].forEach(view.addSubview)
        
        installConstraints()
    }
    
    private func installConstraints() {
        flagOne.snp.makeConstraints {
//            $0.width.equalTo(200.0)
//            $0.height.equalTo(100.0)
            
            $0.top.equalToSuperview().offset(100.0)
            $0.centerX.equalToSuperview()
        }
        
        flagTwo.snp.makeConstraints {
//            $0.width.equalTo(200.0)
//            $0.height.equalTo(100.0)
            
            $0.top.equalToSuperview().offset(230.0)
            $0.centerX.equalToSuperview()
        }
        
        flagThree.snp.makeConstraints {
//            $0.width.equalTo(200.0)
//            $0.height.equalTo(100.0)
            
            $0.top.equalToSuperview().offset(360.0)
            $0.centerX.equalToSuperview()
        }
    }
}
