//
//  HomeTableViewController.swift
//  Storm Viewer
//
//  Created by Maciej Helmecki on 14/06/2023.
//

import Combine
import UIKit

class HomeTableViewModel {
    // MARK: - Properties
    
    @Published private(set) var models = [CellModel]()
    
    private(set) var selectedImageTitle = String()
    var numberOfRows: Int { models.count }
    
    // MARK: - Init
    
    init() {
        fetchItems()
    }
    
    // MARK: - Methods
    
    private func fetchItems() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)

        for item in items {
            if item.hasPrefix("nssl") {
                models.append(CellModel(title: item))
            }
        }
        
        models.sort()
    }
}

// MARK: - HomeTableViewController

class HomeTableViewController: UITableViewController {
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: HomeTableViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(shareTapped))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        viewModel = HomeTableViewModel()
        
        setupView()
        bindView()

        
    }
    
    // MARK: - Methods
    
    private func setupView() {
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func bindView() {
        viewModel.$models
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }.store(in: &cancellables)
    }
}

extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        cell.textLabel?.text = viewModel.models[indexPath.row].title
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.selectedImageName = viewModel.models[indexPath.row].title
        
        let imagesAmount = viewModel.models.count
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

struct CellModel {
    let title: String
}

extension CellModel: Comparable {
    static func < (lhs: CellModel, rhs: CellModel) -> Bool {
        lhs.title < rhs.title
    }
}
