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
