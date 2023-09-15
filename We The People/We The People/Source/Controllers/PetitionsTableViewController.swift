import UIKit

class PetitionsTableViewController: UITableViewController {
    // MARK: - Properties
    
    var petitionsService: PetitionsService!
    
    private var petitions: [Petition] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        loadData()
    }
    
    // MARK: - Methods
    
    private func setupView() {
        title = "Petitions"
    }
    
    private func loadData() {
        petitionsService.loadData { [weak self] petitions in
            self?.petitions = petitions
            self?.tableView.reloadData()
        }
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
        
        cell.textLabel?.text = petitions[indexPath.row].title
        cell.detailTextLabel?.text = petitions[indexPath.row].body
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}
