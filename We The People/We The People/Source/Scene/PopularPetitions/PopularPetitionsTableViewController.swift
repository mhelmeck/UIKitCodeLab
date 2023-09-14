import UIKit
import Combine

class PopularPetitionsTableViewController: UITableViewController {
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: PopularPetitionsViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = PopularPetitionsViewModel()
        
        setupView()
        bindView()
    }
    
    // MARK: - Methods
    
    private func setupView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func bindView() {
        
    }
}

extension PopularPetitionsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 16
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Test"
        
        return cell
    }
}
