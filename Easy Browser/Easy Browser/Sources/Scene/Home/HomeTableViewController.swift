//
//  HomeTableViewController.swift
//  Easy Browser
//
//  Created by Maciej Helmecki on 28/06/2023.
//

import UIKit

class HomeTableViewController: UITableViewController {
    // MARK: - Properties
    
    private var websites: [Website] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        setupView()
        loadData()
        
        tableView.reloadData()
    }
    
    // MARK: - Methods
    
    private func setupView() {
        title = "Websites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func loadData() {
        guard let path = Bundle.main.path(forResource: "Websites", ofType: "json") else {
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let result = try decoder.decode(WebsiteList.self, from: jsonData)
            
            websites = result.websites
        } catch {}
    }
}

extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row].title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = WebsiteViewModel(websites: websites, selectedIndex: indexPath.row)
        let vc = WebsiteViewController()
        vc.viewModel = viewModel
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
