//
//  HomeTableViewController.swift
//  Easy Browser
//
//  Created by Maciej Helmecki on 28/06/2023.
//

import Combine
import UIKit

class HomeTableViewController: UITableViewController {
    // MARK: - Properties
    
    private var viewModel: HomeTableViewViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = HomeTableViewViewModel()
    
        setupView()
        bindView()
    }
    
    // MARK: - Methods
    
    private func setupView() {
        title = "Websites"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func bindView() {
        viewModel.$websites
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }.store(in: &cancellables)
    }
}

extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = viewModel.websites[indexPath.row].title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = WebsiteViewModel(websites: viewModel.websites, selectedIndex: indexPath.row)
        let vc = WebsiteViewController()
        vc.viewModel = viewModel
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
