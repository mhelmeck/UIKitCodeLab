//
//  HomeTableViewController.swift
//  Word Scramble
//
//  Created by Maciej Helmecki on 30/06/2023.
//

import UIKit

class HomeTableViewController: UITableViewController {
    // MARK: - Properties
    
    private var viewModel: HomeViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = HomeViewModel()
        
        setupView()
        
        startGame()
    }
    
    // MARK: - Methods
    
    private func setupView() {
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func startGame() {
        title = viewModel.homeTitle
        viewModel.removeUsedWords()
        
        tableView.reloadData()
    }
        
    private func submit(_ answer: String) {
        print(answer)
    }
    
    @objc private func promptForAnswer() {
        let alertVC = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        alertVC.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alertVC] _ in
            guard let answer = alertVC?.textFields?.first?.text else {
                return
            }
            
            self?.submit(answer)
        }
        
        alertVC.addAction(submitAction)
        present(alertVC, animated: true)
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
