//
//  ViewController.swift
//  Storm Viewer
//
//  Created by Maciej Helmecki on 14/06/2023.
//

import UIKit

class ViewController: UITableViewController {
    // MARK: - Properties
    
    private var imageNames = [String]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

extension ViewController {
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
}
