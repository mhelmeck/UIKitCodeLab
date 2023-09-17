import UIKit

class PetitionsTableViewController: UITableViewController {
    // MARK: - Properties
    
    var petitionsService: PetitionsService!
    
    private var filterKey: String?
    
    private var originalData: [Petition] = [] {
        didSet {
            filteredData = originalData
        }
    }
    
    private var filteredData: [Petition] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        loadData()
    }
    
    // MARK: - Methods
    
    private func setupView() {
        title = "Petitions"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchFor))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Credits",
            style: .plain,
            target: self, 
            action: #selector(showInfo)
        )
    }
    
    private func loadData() {
        guard let urlString = getUrlString() else {
            showError()
            return
        }
        
        petitionsService.loadData(from: urlString) { [weak self] result in
            switch result {
            case .success(let petitions):
                self?.originalData = petitions
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
        showAlert(
            title: "Loading error",
            message: "There was a problem loading the feed; please check your connection and try again."
        )
    }
    
    @objc private func showInfo() {
        showAlert(
            title: "Info",
            message: "Data comes from the We The People API of the Whitehouse"
        )
    }
    
    @objc private func searchFor() {
        let ac = UIAlertController(title: "Search for:", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.textFields?.first?.text = filterKey
        
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak ac] _ in
            let key = ac?.textFields?.first?.text ?? ""
            
            self?.filterData(with: key)
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        
        present(ac, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(ac, animated: true)
    }
    
    private func filterData(with key: String) {
        filterKey = key
        guard !key.isEmpty else {
            filteredData = originalData
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            let filtered = self.originalData.filter {
                $0.title.contains(key)
            }
            
            DispatchQueue.main.async {
                self.filteredData = filtered
            }
        }
    }
}

extension PetitionsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let reusedCell = tableView.dequeueReusableCell(withIdentifier: "PetitionsCell") {
            cell = reusedCell
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "PetitionsCell")
        }
        
        cell.textLabel?.text = filteredData[indexPath.row].title
        cell.detailTextLabel?.text = filteredData[indexPath.row].body
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.petition = filteredData[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
