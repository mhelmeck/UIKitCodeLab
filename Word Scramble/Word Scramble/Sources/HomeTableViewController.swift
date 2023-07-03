//
//  HomeTableViewController.swift
//  Word Scramble
//
//  Created by Maciej Helmecki on 30/06/2023.
//

import UIKit

class HomeTableViewController: UITableViewController {
    // MARK: - Properties
    
    var allWords = [String]()
    var usedWords = [String]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.backgroundColor = .white
        
        loadData()
        startGame()
    }
    
    // MARK: - Methods
    
    private func loadData() {
        guard let url = Bundle.main.url(forResource: "words", withExtension: "txt"),
             let words = try? String(contentsOf: url) else {
            return
        }
        
        allWords = words.components(separatedBy: "\n")
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
    }
    
    private func startGame() {
        title = allWords.randomElement()?.capitalized
        
        usedWords.removeAll(keepingCapacity: true)
        
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
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        
        return cell
    }
}
