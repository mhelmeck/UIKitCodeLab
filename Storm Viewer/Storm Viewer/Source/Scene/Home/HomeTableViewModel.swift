import Combine
import Foundation

class HomeViewModel {
    // MARK: - Properties
    
    let homeTitle = "Storm Viewer"
    let shareTitle = "Check out this amazing app!"
    let shareURL = URL(string: "https://www.hackingwithswift.com")
    
    @Published private(set) var models = [ImageModel]()
    
    private var counterDict: [String: Int] = [:]
    
    // MARK: - Init
    
    init() {
        fetchItems()
    }
    
    // MARK: - Methods
        
    func imageExtendedTitle(for index: Int) -> String? {
        guard index >= 0 && index < models.count else {
            return nil
        }
        
        let amount = models.count
        let selectedPosition = index + 1
        
        return "Picture \(selectedPosition) of \(amount)"
    }
    
    func logVisit(on model: ImageModel) {
        let userDefaults = UserDefaults.standard
        model.amount += 1
        counterDict[model.title] = model.amount
        
        userDefaults.setValue(counterDict, forKey: "counterDict")
    }
}

private extension HomeViewModel {
    func fetchItems() {
        DispatchQueue.global(qos: .background).async {
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let content = try! fm.contentsOfDirectory(atPath: path)
            
            var titles = [String]()
            for item in content {
                if item.hasPrefix("nssl") { titles.append(item) }
            }
            
            let cachedDict = self.readCounterDict()
            for title in titles {
                let amount = cachedDict[title] ?? 0
                self.counterDict[title] = amount
            }
            
            self.models = self.counterDict
                .map { ImageModel(title: $0.key, amount: $0.value) }
                .sorted()
        }
    }
    
    private func readCounterDict() -> [String: Int] {
        let userDefaults = UserDefaults.standard
        guard let dict = userDefaults.object(forKey: "counterDict") as? [String: Int] else {
            return [:]
        }
        
        return dict
    }
}
