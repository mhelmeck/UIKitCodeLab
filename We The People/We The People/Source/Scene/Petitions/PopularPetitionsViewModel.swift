import Combine
import Foundation

class PopularPetitionsViewModel: PetitionsViewModel {
    // MARK: - Properties
        
    var petitionsPublisher: Published<[String]>.Publisher { $petitions }
    
    @Published private var petitions: [String] = []
    
    // MARK: - Init
    
    init() {
        
    }
    
    // MARK: - Methods
}

