import Combine
import Foundation

class RecentPetitionsViewModel: PetitionsViewModel {
    // MARK: - Properties
    
    var petitionsPublisher: Published<[Petition]>.Publisher { $petitions }
    
    @Published private var petitions: [Petition] = []
    
    // MARK: - Init
    
    init() {
        loadData()
    }
    
    // MARK: - Methods
    
    private func loadData() {
        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        guard let url = URL(string: urlString) else {
            return
        }
        
        Task {
            let data = await getData(from: url)
            parse(data)
        }
    }
    
    private func getData(from url: URL) async -> Data? {
        return try? Data(contentsOf: url)
    }
    
    private func parse(_ data: Data?) {
        guard let data = data else {
            return
        }
        
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: data) {
            petitions = jsonPetitions.results
        }
    }
}
