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
        guard let urlString = getUrlString() else {
            showError()
            return
        }
        
        petitionsService.loadData(from: urlString) { [weak self] result in
            switch result {
            case .success(let petitions):
                self?.petitions = petitions
                self?.tableView.reloadData()
            case .failure:
                self?.showError()
            }
        }
    }
    
    private func getUrlString() -> String? {
        switch tabBarController?.selectedIndex {
        case 0:
            return "https://www.hackingwithswift.com/samples/petitions-1.json"
        case 1:
            return "https://www.hackingwithswift.com/samples/petitions-2.json"
        default:
            return nil
        }
    }
    
    private func showError() {
        let ac = UIAlertController(
            title: "Loading error",
            message: "There was a problem loading the feed; please check your connection and try again.",
            preferredStyle: .alert
        )
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(ac, animated: true)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.petition = petitions[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
