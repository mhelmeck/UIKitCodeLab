//
//  HomeTableViewController.swift
//  Word Scramble
//
//  Created by Maciej Helmecki on 30/06/2023.
//

import Combine
import UIKit

class HomeTableViewController: UITableViewController {
    // MARK: - Properties
    
    private var viewModel: HomeViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = HomeViewModel()
        
        setupView()
        bindData()
    }
    
    // MARK: - Methods
    
    private func setupView() {
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadGame))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func bindData() {
        viewModel.reloadDataSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.tableView.reloadData()
            }.store(in: &cancellables)
        
        viewModel.$title
            .receive(on: DispatchQueue.main)
            .sink { [weak self] title in
                self?.title = title
            }.store(in: &cancellables)
        
        viewModel.$alertModel
            .dropFirst()
            .sink { [weak self] model in
            self?.showAlert(model: model)
        }.store(in: &cancellables)
    }
    
    private func showAlert(model: AlertModel) {
        let alertVC = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "Ok", style: .default)
        
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }
    
    @objc private func promptForAnswer() {
        let alertVC = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        alertVC.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alertVC] _ in
            guard let answer = alertVC?.textFields?.first?.text else {
                return
            }
            
            self?.viewModel.submit(answer) { indexPath in
                self?.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertVC.addAction(submitAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true)
    }
    
    @objc private func reloadGame() {
        viewModel.startGame()
    }
}

extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = viewModel.usedWord(for: indexPath.row)
        
        return cell
    }
}
