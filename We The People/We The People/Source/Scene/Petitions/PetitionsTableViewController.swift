import UIKit
import Combine

class PetitionsTableViewController: UITableViewController {
    // MARK: - Properties
    
    var viewModel: PetitionsViewModel!
    
    private var petitions: [String] = []
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bindView()
    }
    
    // MARK: - Methods
    
    private func setupView() {

    }
    
    private func bindView() {
        viewModel.petitionsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] petitions in
                self?.petitions = petitions
                self?.tableView.reloadData()
            }.store(in: &cancellables)
    }
}

extension PetitionsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let reusedCell = tableView.dequeueReusableCell(withIdentifier: "PetitionsCell") {
            cell = reusedCell
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "PetitionsCell")
        }
        
        cell.textLabel?.text = "Title"
        cell.detailTextLabel?.text = "Details"
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}
