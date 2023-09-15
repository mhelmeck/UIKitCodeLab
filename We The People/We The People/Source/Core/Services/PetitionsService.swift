import Combine
import Foundation

class PetitionsService {
    
    enum PetitionsServiceError: Error {
        case general
    }
    
    // MARK: - Properties
    
    // MARK: - Init
    
    init() {}
    
    // MARK: - Methods
    
    func loadData(from urlString: String, completion: @MainActor @escaping (Result<[Petition], PetitionsServiceError>) -> Void) {
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
    
    private func decode(_ data: Data?) -> Result<[Petition], PetitionsServiceError> {
        guard let data = data else {
            return .failure(.general)
        }
        
        let decoder = JSONDecoder()
        guard let jsonPetitions = try? decoder.decode(Petitions.self, from: data) else {
            return .failure(.general)
        }
        
        return .success(jsonPetitions.results)
    }
}
