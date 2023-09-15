import Combine
import Foundation

class PetitionsService {
    // MARK: - Properties
    
    // MARK: - Init
    
    init() {}
    
    // MARK: - Methods
    
    func loadData(completion: @MainActor @escaping ([Petition]) -> Void) {
        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        guard let url = URL(string: urlString) else {
            return
        }
        
        Task {
            let rawData = await fetch(from: url)
            let result = decode(rawData)
            
            await completion(result)
        }
    }
    
    private func fetch(from url: URL) async -> Data? {
        return try? Data(contentsOf: url)
    }
    
    private func decode(_ data: Data?) -> [Petition] {
        guard let data = data else {
            return []
        }
        
        let decoder = JSONDecoder()
        guard let jsonPetitions = try? decoder.decode(Petitions.self, from: data) else {
            return []
        }
        
        return jsonPetitions.results
    }
}
