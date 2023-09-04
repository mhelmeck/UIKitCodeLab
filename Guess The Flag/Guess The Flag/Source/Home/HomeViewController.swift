//
//  HomeViewController.swift
//  Guess The Flag
//
//  Created by Maciej Helmecki on 16/06/2023.
//

import Combine
import UIKit
import SnapKit

class HomeViewController: UIViewController {
    // MARK: - Properties
    
    private var viewModel: HomeViewModel!
    private var cancellables = Set<AnyCancellable>()
    
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = HomeViewModel()
        
        setupView()
        bindView()
        play()
    }
    
    // MARK: - Methods
    private func setupView() {
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(shareTapped))
        
        [flagOne, flagTwo, flagThree].forEach {
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
        
        view.addSubview(stackView)
        [flagOne, flagTwo, flagThree].forEach(stackView.addArrangedSubview)
        
        installConstraints()
    }
    
    private func bindView() {
        viewModel.$alertModel.sink { [weak self] model in
            self?.showAlert(model: model)
        }.store(in: &cancellables)
        
        viewModel.$homeTitle.sink { [weak self] title in
            self?.title = title
        }.store(in: &cancellables)
        
        viewModel.$flagOneImageName.sink { [weak self] name in
            self?.flagOne.setBackgroundImage(UIImage(named: name), for: .normal)
        }.store(in: &cancellables)
        
        viewModel.$flagTwoImageName.sink { [weak self] name in
            self?.flagTwo.setBackgroundImage(UIImage(named: name), for: .normal)
        }.store(in: &cancellables)
        
        viewModel.$flagThreeImageName.sink { [weak self] name in
            self?.flagThree.setBackgroundImage(UIImage(named: name), for: .normal)
        }.store(in: &cancellables)
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        viewModel.buttonTapped(tag: sender.tag)
    }
    
    private func showAlert(model: AlertModel) {
        let alertVC = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        alertVC.addAction(UIAlertAction(title: model.actionTitle, style: .default, handler: { _ in
            model.action?()
        }))
        
        present(alertVC, animated: true)
    }
    
    private func installConstraints() {
        stackView.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
    }
    
    private func play(action: UIAlertAction? = nil) {
        viewModel.play()
    }
            
    @objc private func shareTapped() {
        let alertVC = UIAlertController(
            title: "Current score!",
            message: "\(viewModel.score)",
            preferredStyle: .alert
        )
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default))
        
        present(alertVC, animated: true)
    }
}
