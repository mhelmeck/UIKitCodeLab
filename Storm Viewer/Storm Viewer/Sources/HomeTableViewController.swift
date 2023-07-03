//
//  HomeTableViewController.swift
//  Storm Viewer
//
//  Created by Maciej Helmecki on 14/06/2023.
//

import UIKit

class HomeTableViewController: UITableViewController {
    // MARK: - Properties
    
    private var imageNames = [String]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(shareTapped))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        setupView()
        fetchItems()
    }
    
    // MARK: - Methods
    
    private func setupView() {
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func fetchItems() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)

        for item in items {
            if item.hasPrefix("nssl") {
                imageNames.append(item)
            }
        }
        
        imageNames.sort()
    }
}

extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        cell.textLabel?.text = imageNames[indexPath.row]
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.selectedImageName = imageNames[indexPath.row]
        
        let imagesAmount = imageNames.count
        let selectedImagePosition = indexPath.row + 1
        let screenTitle = "Picture \(selectedImagePosition) of \(imagesAmount)"
        vc.screenTitle = screenTitle
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func shareTapped() {
        let textToShare = "Check out this amazing app!"
        
        if let appURL = URL(string: "https://www.hackingwithswift.com") {
            let vc = UIActivityViewController(activityItems: [textToShare, appURL], applicationActivities: nil)
            
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true)
        }
    }
}
