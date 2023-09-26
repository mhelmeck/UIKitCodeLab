import UIKit
import Combine

// MARK: - HomeTableViewController

class HomeTableViewController: UITableViewController {
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: HomeViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = HomeViewModel()
        
        setupView()
        bindView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
        
    // MARK: - Methods
    
    private func setupView() {
        title = viewModel.homeTitle
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(shareTapped))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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
        return viewModel.models.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        cell.textLabel?.text = model.title + " (Read \(model.amount))"
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.models[indexPath.row]
        
        let selectedModelTitle = model.title
        let detailsTitle = viewModel.imageExtendedTitle(for: indexPath.row)
        
        let detailsViewModel = DetailsViewModel(selectedModelTitle: selectedModelTitle, detailsTitle: detailsTitle)
        let vc = DetailViewController()
        vc.viewModel = detailsViewModel
        
        viewModel.logVisit(on: model)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func shareTapped() {
        let textToShare = viewModel.shareTitle
        
        if let appURL = viewModel.shareURL {
            let vc = UIActivityViewController(activityItems: [textToShare, appURL], applicationActivities: nil)
            
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true)
        }
    }
}
